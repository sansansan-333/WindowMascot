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
        let contentView = ContentView()
        
        // https://stackoverflow.com/questions/66341414/is-there-a-way-not-to-show-a-window-for-a-swiftui-lifecycle-macos-app
        // close default window, but just workaround
        var window: NSWindow? = NSApplication.shared.windows.first
        if window != nil{
            window!.close()
        }

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1, height: 1),
            styleMask: [],
            backing: .buffered, defer: false)
        window!.center()
        window!.setFrameAutosaveName("Main Window")
        
        WindowController.init(window: window).windowDidLoad() // directly calling windowDidLoad might be illegal, but otherwise never called!!!
        window!.contentView = NSHostingView(rootView: contentView)
        window!.makeKeyAndOrderFront(nil)
        
        GameManager.shared.setWindow(window!)
        GameManager.shared.Awake()
    }
}

@main
struct WindowMascotApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            Text("initial window")
        }
    }
    
    init(){}
}

