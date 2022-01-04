//
//  WindowUtil.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import Foundation
import AppKit

class WindowController: NSWindowController, NSWindowDelegate{
    override func windowDidLoad() {
        super.windowDidLoad()
        
        transparentizeWindow(window!)
        placeWindowFrontmost(window!)
    }
    
    /// make window's background and menubar invisible
    private func transparentizeWindow(_ window: NSWindow){
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.hasShadow = false
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        window.styleMask.remove(.titled)
        window.isMovableByWindowBackground = true
        
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
    }

    /// make a window always frontmost
    private func placeWindowFrontmost(_ window: NSWindow){
        window.collectionBehavior = .canJoinAllSpaces
        window.collectionBehavior = .fullScreenAuxiliary
        window.level = .floating
    }
}

/// make window's background and menubar invisible
func transparentizeWindow(_ window: NSWindow){
    window.isOpaque = false
    window.backgroundColor = NSColor.clear
    window.hasShadow = false
    window.titlebarAppearsTransparent = true
    window.titleVisibility = .hidden
    window.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
    //window.styleMask.insert(NSWindow.StyleMask.borderless)
    
    window.standardWindowButton(.miniaturizeButton)?.isHidden = true
    window.standardWindowButton(.closeButton)?.isHidden = true
    window.standardWindowButton(.zoomButton)?.isHidden = true
}

/// make a window always frontmost
func placeWindowFrontmost(_ window: NSWindow){
    window.collectionBehavior = .canJoinAllSpaces
    window.collectionBehavior = .fullScreenAuxiliary
    window.level = .floating
}

func translateWindow(_ window: NSWindow, relativePosition: NSPoint){
    let origin = window.frame.origin
    let (x, y) = (origin.x, origin.y)
    let p = NSPoint(x: x+relativePosition.x, y:y+relativePosition.y)
    window.setFrameOrigin(p)
}

func translateWindow(_ window: NSWindow, position: NSPoint){
    window.setFrameOrigin(position)
}


func scaleWindow(_ window: NSWindow, size: NSSize){
    window.setContentSize(size)
}
