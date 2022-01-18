//
//  Physics2D.swift
//  WindowMascot
//  
//  Created on 2022/01/15
//  
//

import Foundation

class Physics2D: ObservableObject{
    var objects: [Object2D] = []
    
    // constant
    @Published var gravity: Double = 9.8
    static let gravityRange = 0...1000.0
    
    init(){}
    
    
    func Step(elapsed: Double){
        // apply force
        MoveObjects(elapsed)
        
        // collision
        if !objects.isEmpty{
            for i in 0..<objects.count-1 {
                for j in i+1..<objects.count {
                    CalcCollision(obj1: objects[i], obj2: objects[j])
                }
            }
        }
    }
    
    ///
    private func MoveObjects(_ elapsed: Double){
        for i in 0..<objects.count{
            var obj = objects[i]
            
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
    private func CalcCollision(obj1: Object2D, obj2: Object2D){
        
    }
}
