//
//  Object2D.swift
//  WindowMascot
//  
//  Created on 2022/01/15
//  
//

// https://thinkit.co.jp/article/8467

import Foundation
import SwiftUI

enum BodyType{
    case Static
    case Dynamic
}

protocol Object2D: AnyObject{
    var bodyType: BodyType{ get set }
    var position: Vector2{ get set }
    
    var v: Vector2{ get set }
    var acc: Vector2{ get set }
    var force: Vector2{ get set }
    var m: Double{ get }
    
    var name: String{ get }
    
    func addForce(force: Vector2)
}

class Rectangle: Object2D{
    var bodyType: BodyType
    var position: Vector2
    var width: Double
    var height: Double
    
    var v: Vector2 = Vector2.zero
    var acc: Vector2 = Vector2.zero
    var force: Vector2 = Vector2.zero
    var m: Double
    var friction: Double
    
    var name: String
    
    init(bodyType: BodyType, position: Vector2, width: Double, height: Double, mass: Double, friction: Double, name: String = ""){
        self.bodyType = bodyType
        self.position = position
        self.width = width
        self.height = height
        
        self.m = mass
        self.friction = friction
        
        self.name = name
    }
    
    func addForce(force: Vector2){
        self.force += force
    }
}

class Line: Object2D{
    var bodyType: BodyType
    var position: Vector2
    var p0: Vector2
    var p1: Vector2
    
    var v: Vector2 = Vector2.zero
    var acc: Vector2 = Vector2.zero
    var force: Vector2 = Vector2.zero
    var m: Double
    var friction: Double
    
    var name: String
    
    init(bodyType: BodyType, mass: Double, friction: Double, p0: Vector2, p1: Vector2, name: String = ""){
        self.bodyType = bodyType
        self.position = (p0 + p1) / 2
        
        self.m = mass
        self.friction = friction
        
        self.p0 = p0
        self.p1 = p1
        
        self.name = name
    }
    
    func addForce(force: Vector2){
        self.force += force
    }
}

class Circle: Object2D{
    var bodyType: BodyType
    var position: Vector2
    var r: Double
    
    var v: Vector2 = Vector2.zero
    var acc: Vector2 = Vector2.zero
    var force: Vector2 = Vector2.zero
    var m: Double
    
    var name: String
    
    init(bodyType: BodyType, position: Vector2, mass: Double, r: Double, name: String = ""){
        self.bodyType = bodyType
        self.position = position
        self.r = r
        
        self.m = mass
        
        self.name = name
    }
    
    func addForce(force: Vector2){
        self.force += force
    }
}
