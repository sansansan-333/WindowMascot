//
//  Gizmo.swift
//  WindowMascot
//  
//  Created on 2022/02/01
//  
//

import Foundation
import AppKit

/// Draws objects' shape in physics engine
class GizmoView: NSView{
    private var physicsEngine: Physics2D?
    
    private var active = true
    
    override init(frame frameRect: NSRect){
        super.init(frame: frameRect)
    }
    
    // なにこれ？
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhysicsEngine(physicsEngine: Physics2D){
        self.physicsEngine = physicsEngine
    }
    
    /// the implementation of this method should be as fast as possible according to https://developer.apple.com/documentation/appkit/nsview/1483686-draw
    override func draw(_ dirtyRect: NSRect) {
        if active && physicsEngine != nil{
            for obj in physicsEngine!.objects{
                // set color
                if obj.bodyType == .Static{
                    NSColor.blue.set()
                }else if obj.bodyType == .Dynamic{
                    NSColor.red.set()
                }else{
                    NSColor.magenta.set()
                }
                
                // draw path
                var path: NSBezierPath = NSBezierPath()
                if obj is Rectangle{
                    let rect = obj as! Rectangle
                    path = NSBezierPath(rect: NSRect(x: rect.position.x, y: rect.position.y, width: rect.width, height: rect.height))
                }else if obj is Line{
                    let line = obj as! Line
                    path.move(to: NSPoint(line.p0))
                    path.line(to: NSPoint(line.p1))
                }else if obj is Circle{
                    let c = obj as! Circle
                    path = NSBezierPath(ovalIn: NSRect(x: c.position.x, y: c.position.y, width: c.r, height: c.r))
                }else{
                    Logger.shared.write(log: "Unexpected object\n")
                    continue
                }
                path.lineWidth = 1
                path.stroke()
            }
        }
    }
    
    func activate(){
        active = true
    }
    
    func deactivate(){
        active = false
    }
}
