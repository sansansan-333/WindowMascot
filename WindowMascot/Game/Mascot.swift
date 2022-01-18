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
    
    var physics: Bool = false
    private var physicsObject: Object2D?
    
    @Published var imageFileName: String
    
    var window: NSWindow
    
    init(position: NSPoint, size: NSSize, anchor: NSPoint, imageFileName: String, window: NSWindow){
        self.position = position
        self.size = size
        self.anchor = anchor
        self.imageFileName = imageFileName
        self.window = window
    }
    
    /// Update position based on own physics object's position
    func UpdatePosition(){
        if !physics || physicsObject == nil{
            return
        }
        
        // TODO
        position = NSPoint(physicsObject!.position)
        translateWindow(window, position: position)
    }
    
    /// Make this mascot physics object
    func AttachPhysics(physicsObject: Object2D, engine: Physics2D){
        self.physicsObject = physicsObject
        engine.objects.append(physicsObject)
        physics = true
    }
}
