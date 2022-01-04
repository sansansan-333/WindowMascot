//
//  Mascot.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import Foundation

class Mascot{
    var position: NSPoint // screen relative
    var size: NSSize
    var anchor: NSPoint // window relative
    
    var imageFileName: String
    
    init(position: NSPoint, size: NSSize, anchor: NSPoint, imageFileName: String){
        self.position = position
        self.size = size
        self.anchor = anchor
        self.imageFileName = imageFileName
    }
}
