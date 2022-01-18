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
    
    var physicsEngine: Physics2D = Physics2D()
    
    // debug variable
    var frameCount: Int = 1
    var logCount: Int = 0
    let logger = Logger.shared
    
    private init(){}
    
    ///
    func Awake(){
        timer = Timer.scheduledTimer(withTimeInterval: GameManager.shared.secondPerFrame, repeats: true){ tempTimer in
            if !self.isStarted{
                self.Start()
            }
            self.Update()
        }
    }
    
    ///
    private func Start(){
        let circle = Circle(bodyType: .Dynamic, position: Vector2(500, 1000), mass: 10)
        generateMascot(position: NSPoint(x: 500, y: 500), size: NSSize(width: 50, height: 50), imageFileName: "pachinko_ball", physicsObject: circle)
        
        isStarted = true
    }
    
    /// Update is called once per frame
    private func Update(){
        // process physics
        physicsEngine.Step(elapsed: secondPerFrame)
        for mascot in mascots{
            mascot.UpdatePosition()
        }
        
        // getWindowList(.optionOnScreenOnly)
    }
    
    ///
    func generateMascot(position: NSPoint = NSPoint(x:0, y:0), size: NSSize, anchor: NSPoint = NSPoint(x:0, y:0), imageFileName: String, physicsObject: Object2D? = nil){
        let window = generateEmptyWindow()
        scaleWindow(window, size: size)
        translateWindow(window, position: sub(position, anchor))
        
        let mascot = Mascot(position: position, size: size, anchor: anchor, imageFileName: imageFileName, window: window)
        translateWindow(window, position: sub(mascot.position, mascot.anchor))
        
        window.contentView = NSHostingView(rootView: ContentView(mascot: mascot))
        window.makeKeyAndOrderFront(nil)
        
        if physicsObject != nil{
            mascot.AttachPhysics(physicsObject: physicsObject!, engine: physicsEngine)
        }
        
        mascots.append(mascot)
    }
    
    // This will be called when secondPerFrame is changed
    private func updateTimer(){
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: GameManager.shared.secondPerFrame, repeats: true){ tempTimer in
            if !self.isStarted{
                self.Start()
            }
            self.Update()
        }
    }
    
    ///
    private func stopTimer(){
        timer?.invalidate()
    }
}
