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

