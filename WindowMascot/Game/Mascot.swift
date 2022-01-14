//
//  Mascot.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import Foundation
import AppKit

class Mascot: ObservableObject{
    var position: NSPoint // screen relative
    @Published var size: NSSize
    var anchor: NSPoint // window relative
    
    @Published var imageFileName: String
    
    var window: NSWindow
    
    init(position: NSPoint, size: NSSize, anchor: NSPoint, imageFileName: String, window: NSWindow){
        self.position = position
        self.size = size
        self.anchor = anchor
        self.imageFileName = imageFileName
        self.window = window
    }
}
