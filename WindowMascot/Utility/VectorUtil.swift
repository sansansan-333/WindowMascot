//
//  VectorUtil.swift
//  WindowMascot
//  
//  Created on 2022/01/12
//  
//

import Foundation

struct Vector2{
    var x: Double
    var y: Double
    
    init(_ x: Double, _ y: Double){
        self.x = x
        self.y = y
    }
    
    init(_ p: NSPoint){
        self.x = p.x
        self.y = p.y
    }
    
    
    // operator
    static func + (left: Vector2, right: Vector2) -> Vector2{
        return Vector2(left.x + right.x, left.y + right.y)
    }
    
    static func - (left: Vector2, right: Vector2) -> Vector2{
        return Vector2(left.x - right.x, left.y - right.y)
    }
    
    static prefix func - (v: Vector2) -> Vector2{
        return Vector2(-v.x, -v.y)
    }
    
    static func += (left: inout Vector2, right: Vector2){
        left = left + right
    }
    
    static func -= (left: inout Vector2, right: Vector2){
        left = left - right
    }
    
    static func == (left: Vector2, right: Vector2) -> Bool{
        return (left.x == right.x) && (left.y == right.y)
    }
    
    static func != (left: Vector2, right: Vector2) -> Bool{
        return !(left == right)
    }
    
    
    // function
    static func dot(_ v1: Vector2, _ v2: Vector2) -> Double{
        return v1.x * v2.x + v1.y * v2.y
    }
    
    func dot(_ v: Vector2) -> Double{
        return Vector2.dot(self, v)
    }
    
    static func cross(_ v1: Vector2, _ v2: Vector2) -> Double{
        return v1.x * v2.y - v2.x * v1.y
    }
    
    func cross(_ v: Vector2) -> Double{
        return Vector2.cross(self, v)
    }
    
    func Length() -> Double{
        return sqrt(x*x + y*y)
    }
    
    mutating func Normalize(){
        let length = Length()
        x /= length
        y /= length
    }
    
    func ToString() -> String{
        return "(\(x), \(y))"
    }
}


extension NSPoint{
    init(vector2: Vector2){
        self.init(x: vector2.x, y: vector2.y)
    }
}

func sub(_ p1: NSPoint, _ p2: NSPoint) -> NSPoint{
    return NSPoint(x: p1.x - p2.x, y: p1.y - p2.y)
}
