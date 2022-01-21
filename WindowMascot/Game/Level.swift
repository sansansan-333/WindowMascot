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
    
    private init(){}
    
    func changeMode(){
        
    }
    
    func construct(){
        guard var windowList: [NSDictionary] = getWindowList(.optionOnScreenOnly) else{
            Logger.shared.write(log: "Something is wrong")
            return
        }
        
        // filter windowList
        windowList = windowList.filter{(windowInfo: NSDictionary) -> Bool in
            if let layer = windowInfo[kCGWindowLayer] as? Int, 0 <= layer, layer <= 3, // if 0 <= layer <= 3
               let ownerName = windowInfo[kCGWindowOwnerName] as? String, ownerName != appName // if a window is't WindowMascot
            {
                return true
            }
            return false
        }
        Logger.shared.write(log: windowList.description + "\n")
    }
}
