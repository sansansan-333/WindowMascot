//
//  Game.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import Foundation
import AppKit

/// GameManager class (singleton)
class GameManager: ObservableObject{
    static let shared = GameManager()
    private var timer: Timer?
    
    static let secondPerFrame = 0.06
    
    var window: NSWindow?
    /// DO NOT change this directly. Use updateWindowSize to set.
    @Published var windowSize: NSSize?
    @Published var isReadyToDraw: Bool = false
    var isReadyToStartGame: Bool{
        return window != nil
    }
    private var isStarted: Bool = false
    
    var mascot: Mascot?
    
    // debug variable
    var frameCount: Int = 1
    var logCount: Int = 0
    let logger = Logger.shared
    
    private init(){}
    
    ///
    func Awake(){
        logger.disable()
        
        timer = Timer.scheduledTimer(withTimeInterval: GameManager.secondPerFrame, repeats: true){ tempTimer in
            if self.isReadyToStartGame{
                if !self.isStarted{
                    self.Start()
                }
                self.Update()
            }
        }
        logger.write(log: "Awake \(String(describing: window?.title))\n")
    }
    
    ///
    private func Start(){
        updateWindowSize(NSSize(width: 50, height: 50))
        mascot = Mascot(position: NSPoint(x:0, y:0), size: windowSize!, anchor: NSPoint(x:0, y:0), imageFileName: "pachinko_ball")
        updateIsReadyToDraw()
        translateWindow(window!, position: sub(mascot!.position, mascot!.anchor))
        
        isStarted = true
        logger.write(log: "Start \(String(describing: window?.title))\n")
    }
    
    /// Update is called once per frame
    private func Update(){
        translateWindow(window!, relativePosition: NSPoint(x: 1, y: 2))
        
        logger.write(log: "Update \(String(describing: window?.title))\n")
        logger.write(log: "\(String(describing: NSApplication.shared.keyWindow?.title))\n")
    }
    
    ///
    func setWindow(_ window: NSWindow){
        self.window = window
    }
    
    ///
    func updateIsReadyToDraw(){
        isReadyToDraw = mascot?.imageFileName != ""
    }
    
    /// Set and update window size
    func updateWindowSize(_ size: NSSize? = nil){
        if size != nil{
            self.windowSize = size
        }
        if window != nil{
            scaleWindow(window!, size: windowSize!)
        }
    }
    
    ///
    private func stopTimer(){
        timer?.invalidate()
    }
}


func sub(_ p1: NSPoint, _ p2: NSPoint) -> NSPoint{
    return NSPoint(x: p1.x - p2.x, y: p1.y - p2.y)
}
