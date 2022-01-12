//
//  ContentView.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MainView()
        }
    }
}

struct MainView: View {
    @ObservedObject var gameManager: GameManager = GameManager.shared
    
    var body: some View {
        if gameManager.isReadyToDraw{
            Image(gameManager.mascot!.imageFileName)
                .resizable()
                .frame(width: gameManager.windowSize?.width, height: gameManager.windowSize?.height)
        }else{
            Text("Loading...")
                .padding()
        }
    }
}

/// Settings view
struct ControlView: View {
    @ObservedObject private var gameManager = GameManager.shared
    
    var body: some View {
        Form {
            // FPS
            Text("sec/frame: \(gameManager.secondPerFrame)")
            Slider(value: $gameManager.secondPerFrame, in: GameManager.secondPerFrameRange)
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

/// WindowMascot > Preference
struct GeneralSettingsView: View {
    var body: some View {
        Form {
            Text("無")
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
