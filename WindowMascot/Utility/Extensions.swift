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

// https://stackoverflow.com/questions/32357060/deep-copy-for-array-of-objects-in-swift
protocol Copying{
    init(original: Self)
}

extension Copying{
    func copy() -> Self{
        return Self.init(original: self)
    }
}

extension Array where Element: Copying{
    func clone() -> Array{
        var copied = Array<Element>()
        for elem in self{
            copied.append(elem.copy())
        }
        return copied
    }
}
