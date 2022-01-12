//
//  VectorUtil.swift
//  WindowMascot
//  
//  Created on 2022/01/12
//  
//

import Foundation

func sub(_ p1: NSPoint, _ p2: NSPoint) -> NSPoint{
    return NSPoint(x: p1.x - p2.x, y: p1.y - p2.y)
}
