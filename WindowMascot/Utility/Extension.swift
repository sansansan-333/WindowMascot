//
//  Extension.swift
//  WindowMascot
//  
//  Created on 2022/01/21
//  
//

import Foundation

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) -> Element?{
        guard let index = firstIndex(of: object) else {return nil}
        return remove(at: index)
    }
}
