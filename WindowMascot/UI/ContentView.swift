//
//  ContentView.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameManager: GameManager = GameManager.shared
    @ObservedObject var mascot: Mascot
    
    init(mascot: Mascot){
        self.mascot = mascot
    }
    
    var body: some View {
        Image(mascot.imageFileName)
            .resizable()
            .frame(width: mascot.size.width, height: mascot.size.height)
    }
}

/// Control view
struct ControlView: View {
    @ObservedObject private var gameManager = GameManager.shared
    
    var body: some View {
        Form {
            // FPS
            HStack(){
                Text("sec/frame: \(gameManager.secondPerFrame)")
                Slider(value: $gameManager.secondPerFrame, in: GameManager.secondPerFrameRange)
            }
            Button(action:{
                gameManager.generateMascot(size: NSSize(width: 50, height: 50), imageFileName: "pachinko_ball")
            }){
                Text("New mascot")
            }
        }
        .padding()
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
