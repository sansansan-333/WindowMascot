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
    
    private var rectangles: [Rectangle] = []
    private var lines: [Line] = []
    var friction: Double = 1
    
    private init(){}
    
    func construct(physicsEngine: Physics2D){
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
        
        if mode == .Rectangles{
            // discard rectangles from engine
            // TODO: make faster
            for i in 0 ..< rectangles.count{
                physicsEngine.discardObject(object: rectangles[i])
            }
                
            rectangles = []
            
            // create rectangles
            for i in 0 ..< windowBounds.count{
                let bound = windowBounds[i]
                // since getWindowList()(technically CGWindowListCopyWindowInfo()) only uses different coordinate system in this project,
                // y position needs to be converted.
                rectangles.append(
                    Rectangle(bodyType: .Static,
                              position: Vector2(bound["X"] as! Double, CGWindowToNSScreenY(cgWindowY: (bound["Y"] as! Double) + (bound["Height"] as! Double))),
                              width: bound["Width"] as! Double,
                              height: bound["Height"] as! Double,
                              mass: 1,
                              friction: self.friction
                    )
                )
            }
            physicsEngine.objects += rectangles
            
        }else if mode == .Lines{
            
        }else{
            Logger.shared.write(log: "LevelMode is not decided.\n")
        }
    }
}
