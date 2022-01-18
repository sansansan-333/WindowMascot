//
//  Object2D.swift
//  WindowMascot
//  
//  Created on 2022/01/15
//  
//

// https://thinkit.co.jp/article/8467

import Foundation

enum BodyType{
    case Static
    case Dynamic
}

protocol Object2D{
    var bodyType: BodyType{ get set }
    var position: Vector2{ get set }
    
    var v: Vector2{ get set }
    var acc: Vector2{ get set }
    var force: Vector2{ get set }
    var m: Double{ get }
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
    
    init(bodyType: BodyType, position: Vector2, width: Double, height: Double, mass: Double, friction: Double){
        self.bodyType = bodyType
        self.position = position
        self.width = width
        self.height = height
        
        self.m = mass
        self.friction = friction
    }
}

class Line: Object2D{
    var bodyType: BodyType
    var position: Vector2
    
    var v: Vector2 = Vector2.zero
    var acc: Vector2 = Vector2.zero
    var force: Vector2 = Vector2.zero
    var m: Double
    var friction: Double
    
    init(bodyType: BodyType, position: Vector2, mass: Double, friction: Double){
        self.bodyType = bodyType
        self.position = position
        
        self.m = mass
        self.friction = friction
    }
}

class Circle: Object2D{
    var bodyType: BodyType
    var position: Vector2
    
    var v: Vector2 = Vector2.zero
    var acc: Vector2 = Vector2.zero
    var force: Vector2 = Vector2.zero
    var m: Double
    
    init(bodyType: BodyType, position: Vector2, mass: Double){
        self.bodyType = bodyType
        self.position = position
        
        self.m = mass
    }
}
