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

/// Move window to a given position relatively
/// Note that numbers after decimal point in *relativePosition* will be ignored
func translateWindow(_ window: NSWindow, relativePosition: NSPoint){
    let origin = window.frame.origin
    let (x, y) = (origin.x, origin.y)
    let p = NSPoint(x: x+relativePosition.x, y:y+relativePosition.y)
    window.setFrameOrigin(p)
}

var appName: String{
    return (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String)!
}

/// Move window to a given position
/// Note that numbers after decimal point in *position* will be ignored
func translateWindow(_ window: NSWindow, position: NSPoint){
    window.setFrameOrigin(position)
}

///
func scaleWindow(_ window: NSWindow, size: NSSize){
    window.setContentSize(size)
}

// https://qiita.com/usagimaru/items/6ffd09c5b27042281108
func getWindowList(_ windowListOption: CGWindowListOption) -> [NSDictionary]?{
    // Generating the dictionaries for system windows is a relatively expensive operation.
    guard let windows: NSArray = CGWindowListCopyWindowInfo(windowListOption, kCGNullWindowID) else {
        return nil
    }
    let swiftWindowList = windows as! [NSDictionary]
    
    return swiftWindowList
}

/// Generate, load and return empty window
func generateEmptyWindow() -> NSWindow{
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 1, height: 1),
        styleMask: [],
        backing: .buffered, defer: false)
    
    WindowController.init(window: window).windowDidLoad() // directly calling windowDidLoad might be illegal, but otherwise it'll never be called!
    
    return window
}
