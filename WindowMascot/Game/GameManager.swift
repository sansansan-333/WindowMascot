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
    
    //var window: NSWindow?
    private var isStarted: Bool = false
    
    var mascots: [Mascot] = []
    
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
        generateMascot(size: NSSize(width: 50, height: 50), imageFileName: "pachinko_ball")
        
        isStarted = true
    }
    
    /// Update is called once per frame
    private func Update(){
        getWindowList(.optionOnScreenOnly)
    }
    
    func generateMascot(position: NSPoint = NSPoint(x:0, y:0), size: NSSize, anchor: NSPoint = NSPoint(x:0, y:0), imageFileName: String){
        let window = generateEmptyWindow()
        scaleWindow(window, size: size)
        translateWindow(window, position: sub(position, anchor))
        
        let mascot = Mascot(position: position, size: size, anchor: anchor, imageFileName: imageFileName, window: window)
        translateWindow(window, position: sub(mascot.position, mascot.anchor))
        
        window.contentView = NSHostingView(rootView: ContentView(mascot: mascot))
        window.makeKeyAndOrderFront(nil)
        
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
