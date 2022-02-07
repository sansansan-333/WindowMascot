//
//  Physics2D.swift
//  WindowMascot
//  
//  Created on 2022/01/15
//  
//

// https://thinkit.co.jp/article/8467

import Foundation

class Physics2D: ObservableObject{
    @Published var objects: [Object2D] = []
    
    // physics constant
    @Published var gravity: Double = 9.8
    static let gravityRange = -100.0...100.0
    
    private var gizmoView: GizmoView?
    private var gizmo: Bool = false // true if gizmo is being shown
    
    init(){}
    
    func step(elapsed: Double){
        // apply force
        moveObjects(elapsed)
        
        if gizmo{
            if isObjectsPositionChanged(){
                gizmoView!.needsDisplay = true
            }
        }
        
        // reset force
        for object in objects {
            object.force = Vector2.zero
        }
        
        // collision
        if objects.count >= 2{
            for i in 0 ..< objects.count-1 {
                for j in i+1 ..< objects.count {
                    calcCollision(obj1: objects[i], obj2: objects[j])
                }
            }
        }
    }
    
    ///
    private func moveObjects(_ elapsed: Double){
        for i in 0..<objects.count{
            let obj = objects[i]
            
            if obj.bodyType == .Static{
                obj.v = Vector2.zero
                obj.acc = Vector2.zero
                obj.force = Vector2.zero
                
            }else if obj.bodyType == .Dynamic{
                obj.acc = obj.force / obj.m + gravity * obj.m * Vector2.down
                obj.v += obj.acc * elapsed
                obj.position += obj.v * elapsed
                
            }else{
                Logger.shared.write(log: "Something is wrong")
            }
        }
    }
    
    ///
    private func calcCollision(obj1: Object2D, obj2: Object2D){
        
    }
    
    /// Remove an object from engine, then return true if existed
    @discardableResult
    func discardObject(object: Object2D) -> Bool{
        for i in 0 ..< objects.count{
            if objects[i] === object{
                objects.remove(at: i)
                return true
            }
        }
        
        return false
    }
    
    /// Discard objects with name.
    /// All the objects that have specified name will be deleted.
    @discardableResult
    func discardObjectsWithName(name: String) -> Bool{
        let countBeforeDelete = objects.count
        
        objects.removeAll( where: {$0.name == name} )
        
        return countBeforeDelete != objects.count
    }
    
    /// Compare position of objects from previous frame, return true if at least one of them are different.
    func isObjectsPositionChanged() -> Bool{
        return true
    }
    
    private func startGizmo() -> GizmoView{
        let window = generateEmptyWindow()
        window.level = .screenSaver
        window.ignoresMouseEvents = true
        
        // expand window to the size of screen
        translateWindow(window, position: NSPoint(x: 0, y: 0))
        scaleWindow(window, size: screenSize)

        let gizmoView = GizmoView(frame: window.contentView!.frame)
        gizmoView.setPhysicsEngine(physicsEngine: self)
        
        window.contentView?.addSubview(gizmoView)
        window.makeKeyAndOrderFront(nil)
        
        return gizmoView
    }
    
    func showGizmo(){
        gizmo = true
        if gizmoView == nil{
            gizmoView = startGizmo()
        }
        gizmoView!.activate()
    }
    
    func hideGizmo(){
        gizmo = false
        if gizmoView != nil{
            gizmoView!.deactivate()
            gizmoView!.needsDisplay = true // redraw to hide
        }
    }
}
