//
//  Game.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import Foundation
import AppKit
import SwiftUI

/// GameManager class (singleton)
class GameManager: ObservableObject{
    static let shared = GameManager()
    private var timer: Timer?
    
    @Published var secondPerFrame = 0.5 {
        didSet(newValue){
            updateTimer()
        }
    }
    static let secondPerFrameRange = 0.016...1
    
    private var isStarted: Bool = false
    
    private var mascots: [Mascot] = []
    
    static var screenLeftBottom: Vector2 = Vector2(-16000, -16000)
    static var screenRightTop: Vector2 = Vector2(16000, 16000)
    var physicsEngine: Physics2D = Physics2D()
    
    var gizmo: GizmoView?
    
    // debug variable
    var frameCount: Int = 1
    var logCount: Int = 0
    let logger = Logger.shared
    
    private init(){}
    
    ///
    func awake(){
        timer = Timer.scheduledTimer(withTimeInterval: GameManager.shared.secondPerFrame, repeats: true){ tempTimer in
            if !self.isStarted{
                self.start()
            }
            self.update()
        }
    }
    
    ///
    private func start(){
        let circle = Circle(bodyType: .Dynamic, position: Vector2(500, 1000), mass: 10, r: 25)
        generateMascot(position: NSPoint(x: 0, y: 0), size: NSSize(width: 50, height: 50), anchor: NSPoint(x: 25, y: 25), imageFileName: "pachinko_ball", physicsObject: nil)
        
        gizmo = startGizmo()
        
        isStarted = true
    }
    
    /// Update is called once per frame
    private func update(){
        // set flag to show gizmo
        // window server will redraw if the flag is true
        if gizmo != nil{
            gizmo!.needsDisplay = true
        }
        
        // remove mascot if it's outside of screen
        // TODO: resolve redundant search
        for mascot in mascots{
            if Vector2(mascot.origin).isInsideOf(v0: GameManager.screenLeftBottom, v1: GameManager.screenRightTop) == false{
                removeMascot(mascot: mascot)
            }
        }
        
        // construct level
        WindowLevel.shared.construct(physicsEngine: physicsEngine)
        
        // process physics
        physicsEngine.step(elapsed: secondPerFrame)
        for mascot in mascots{
            mascot.updatePositionPhysics()
        }
    }
    
    ///
    func generateMascot(position: NSPoint = NSPoint(x:0, y:0), size: NSSize, anchor: NSPoint = NSPoint(x:0, y:0), imageFileName: String, physicsObject: Object2D? = nil){
        let window = generateEmptyWindow()
        
        let mascot = Mascot(position: position, size: size, anchor: anchor, imageFileName: imageFileName, window: window)
        translateWindow(window, position: mascot.origin)
        scaleWindow(window, size: mascot.size)
        
        window.contentView = NSHostingView(rootView: ContentView(mascot: mascot))
        window.makeKeyAndOrderFront(nil)
        
        if physicsObject != nil{
            mascot.attachPhysics(physicsObject: physicsObject!, engine: physicsEngine)
        }
        
        mascots.append(mascot)
    }
    
    /// This will be called when secondPerFrame is changed
    private func updateTimer(){
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: GameManager.shared.secondPerFrame, repeats: true){ tempTimer in
            if !self.isStarted{
                self.start()
            }
            self.update()
        }
    }
    
    ///
    private func stopTimer(){
        timer?.invalidate()
    }
    
    /// Remove a mascot from game, then return true if successfully removed
    @discardableResult
    func removeMascot(mascot: Mascot) -> Bool{
        for i in 0 ..< mascots.count{
            if mascots[i] === mascot{
                return removeMascot(index: i)
            }
        }
        return false
    }
    
    /// Remove a mascot from game, then return true if successfully removed
    @discardableResult
    private func removeMascot(index: Int) -> Bool{
        if index < 0 || mascots.count <= index{
            return false
        }
        
        mascots[index].deattachPhysics() // discard physics object attached to the mascot from physics engine
        mascots.remove(at: index)
        
        return true
    }
    
    private func startGizmo() -> GizmoView{
        let window = generateEmptyWindow()
        window.level = .screenSaver
        window.ignoresMouseEvents = true
        
        // expand window to the size of screen
        translateWindow(window, position: NSPoint(x: 0, y: 0))
        scaleWindow(window, size: screenSize)

        let gizmoView = GizmoView(frame: window.contentView!.frame)
        gizmoView.physicsEngine = self.physicsEngine
        gizmoView.needsDisplay = true
        
        window.contentView?.addSubview(gizmoView)
        window.makeKeyAndOrderFront(nil)
        
        return gizmoView
    }
}
