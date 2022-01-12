//
//  WindowMascotApp.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import SwiftUI

// https://stackoverflow.com/questions/60218622/nswindow-contentview-not-cover-full-window-size-macos-swiftui
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the window and set the content view.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1, height: 1),
            styleMask: [],
            backing: .buffered, defer: false)
        
        WindowController.init(window: window).windowDidLoad() // directly calling windowDidLoad might be illegal, but otherwise never called!
        
        let contentView = ContentView()
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
        GameManager.shared.setWindow(window)
        GameManager.shared.Awake()
    }
}

@main
struct WindowMascotApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ControlView()
        }
        #if os(macOS)
        Settings {
            GeneralSettingsView()
        }
        #endif
    }
    
    init(){}
}

