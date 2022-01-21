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
    var anchor: NSPoint // window relative
    var origin: NSPoint{ // origin position in screen space, use this to set the position of mascot's window
        return sub(position, anchor)
    }
    @Published var size: NSSize
    
    var physics: Bool = false
    private var physicsEngine: Physics2D?
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
    func updatePosition(){
        if !physics{
            return
        }
        
        position = NSPoint(physicsObject!.position)
        translateWindow(window, position: origin)
    }
    
    /// Make this mascot physics object
    func attachPhysics(physicsObject: Object2D, engine: Physics2D){
        self.physicsObject = physicsObject
        physicsEngine = engine
        physicsEngine!.objects.append(physicsObject)
        physics = true
        
        updatePosition()
    }
    
    /// Remove physics component from this mascot.
    /// Attached physics object will be discarded
    func deattachPhysics(){
        if !physics{
            return
        }
        
        physicsEngine!.discardObject(object: physicsObject!)
        physicsObject = nil
        physicsEngine = nil
        physics = false
    }
}
