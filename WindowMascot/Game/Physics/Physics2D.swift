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
    @Published private(set) var objects: [Object2D] = []
    private var previousObjects: [Object2D] = [] // objects in previous frame(step)
    
    // physics constant
    @Published var gravity: Double = 9.8
    static let gravityRange = -100.0...100.0
    
    private var gizmoView: GizmoView?
    private var gizmo: Bool = false // true if gizmo is being shown
    
    init(){}
    
    func step(elapsed: Double){
        // apply force
        moveObjects(elapsed)
        
        // gizmo
        if gizmo{
            if areObjectsChanged(){
                gizmoView!.needsDisplay = true
            }
        }
        
        // store previous frame's objects
        previousObjects = Physics2D.copyObjects(original: objects)
        
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
    
    /// Compare position and size of objects from previous frame and return true if at least one of them are different.
    // TODO: specify area that needs to be checked if any object inside of it is changed
    func areObjectsChanged() -> Bool{
        var currentObjects: [Object2D] = []
        currentObjects += objects
        
        // number of objects
        if previousObjects.count != currentObjects.count{
            Logger.shared.write(log: "1\n")
            return true
        }
        
        // if dynamic object had non-zero velocity in the previous frame, it should be moved
        let prevDynamicObj = previousObjects.filter( {$0.bodyType == .Dynamic} )
        if !prevDynamicObj.filter( {$0.v != Vector2.zero} ).isEmpty{
            Logger.shared.write(log: "2\n")
            return true
        }
        
        let prevStaticObj = previousObjects.filter( {$0.bodyType == .Static} )
        var curStaticObj = objects.filter( {$0.bodyType == .Static} )
        if prevStaticObj.count != curStaticObj.count{
            Logger.shared.write(log: "3\n")
            return true
        }
        // compare type, position and size of static objects
        for prev in prevStaticObj{
            var isSameObjFound = false
            for cur in curStaticObj{
                if type(of: prev) == type(of: cur) && prev.position == cur.position{
                    if prev is Rectangle{
                        if (prev as! Rectangle).height == (cur as! Rectangle).height &&
                            (prev as! Rectangle).width == (cur as! Rectangle).width{
                            isSameObjFound = true
                        }
                    }else if prev is Line{
                        if (prev as! Line).p0 == (cur as! Line).p0 &&
                            (prev as! Line).p1 == (cur as! Line).p1{
                            isSameObjFound = true
                        }
                    }else{
                        if (prev as! Circle).r == (cur as! Circle).r{
                            isSameObjFound = true
                        }
                    }
                }
                
                if isSameObjFound{
                    curStaticObj.remove(at: curStaticObj.firstIndex(where: {$0 === cur})!)
                    break
                }
            }
            if !isSameObjFound{
                Logger.shared.write(log: "4\n")
                return true
            }
        }
        
        
        return false
    }
    
    func addObject(object: Object2D){
        objects.append(object)
        if gizmo && gizmoView != nil{
            gizmoView!.needsDisplay = true
        }
    }
    
    func addObjects(objects: [Object2D]){
        self.objects += objects
        if gizmo && gizmoView != nil{
            gizmoView!.needsDisplay = true
        }
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
        gizmoView!.needsDisplay = true
    }
    
    func hideGizmo(){
        gizmo = false
        if gizmoView != nil{
            gizmoView!.deactivate()
            gizmoView!.needsDisplay = true // redraw to hide
        }
    }
    
    static func copyObject(original: Object2D) -> Object2D{
        if original is Rectangle{
            return (original as! Rectangle).copy()
        }else if original is Line{
            return (original as! Line).copy()
        }else{
            return (original as! Circle).copy()
        }
    }
    
    static func copyObjects(original: [Object2D]) -> [Object2D]{
        return original.map( {copyObject(original: $0)} )
    }
}
