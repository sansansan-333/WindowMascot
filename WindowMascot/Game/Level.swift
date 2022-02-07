//
//  Level.swift
//  WindowMascot
//  
//  Created on 2021/12/31
//  
//

import Foundation
import AppKit

enum LevelMode{
    case Rectangles
    case Lines
}

class WindowLevel{
    static let shared: WindowLevel = WindowLevel()
    
    var mode: LevelMode = .Rectangles
    
    private var physicsEngine: Physics2D?
    private var levelObjects: [Object2D] = []
    let friction: Double = 1
    let levelObjectName: String = "level"
    
    private init(){}
    
    /// Provide construct function to mouse and keyboard events
    // Why we don't call construct function every frame is
    // because the function is heavy due to CGWindowListCopyWindowInfo(),
    // which causes high CPU usage by WindowServer.
    func startConstructingLevel(physicsEngine: Physics2D){
        self.physicsEngine = physicsEngine
        
        // construct first
        WindowLevel.shared.construct()
        
        // event mask used to fire construction event
        let MaskBit = {(cgEventType: CGEventType) -> UInt64 in
            1 << cgEventType.rawValue
        }
        let eventMask = MaskBit(.flagsChanged) | MaskBit(.keyDown) | MaskBit(.leftMouseDragged) | MaskBit(.leftMouseDown) | MaskBit(.leftMouseUp)
        
        // add event
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask(rawValue: eventMask), handler: { (_) -> Void in WindowLevel.shared.construct()
        })
    }
    
    /// Construct level depending on windows on a screen
    private func construct(){
        // get list of windows
        guard var windowList: [NSDictionary] = getWindowList(.optionOnScreenOnly) else{
            Logger.shared.write(log: "No window found.\n")
            return
        }
        
        // filter windowList
        windowList = windowList.filter{(windowInfo: NSDictionary) -> Bool in
            if let layer = windowInfo[kCGWindowLayer] as? Int, 0 <= layer, layer <= 3, // if baseWindow <= layer <= backstopMenu
               let ownerName = windowInfo[kCGWindowOwnerName] as? String, ownerName != appName // if a window is't WindowMascot
            {
                return true
            }
            return false
        }
        
        // we only need windows' position and size
        let windowBounds = windowList.map{ $0[kCGWindowBounds]! as! NSDictionary }
        
        // discard rectangles from engine
        // TODO: make faster
        physicsEngine!.discardObjectsWithName(name: levelObjectName)
        levelObjects = []
        
        if mode == .Rectangles{
            // create rectangles
            for i in 0 ..< windowBounds.count{
                let bound = windowBounds[i]
                // Since getWindowList()(technically CGWindowListCopyWindowInfo()) only uses different coordinate system in this project,
                // y position needs to be converted.
                levelObjects.append(
                    Rectangle(bodyType: .Static,
                              position: Vector2(bound["X"] as! Double, CGWindowToNSScreenY(cgWindowY: (bound["Y"] as! Double) + (bound["Height"] as! Double))),
                              width: bound["Width"] as! Double,
                              height: bound["Height"] as! Double,
                              mass: 1,
                              friction: self.friction,
                              name: levelObjectName
                    )
                )
            }
            physicsEngine!.objects += levelObjects
            
        }else if mode == .Lines{
            
        }else{
            Logger.shared.write(log: "LevelMode is not decided.\n")
        }
    }
}
