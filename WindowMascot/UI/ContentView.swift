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
    @ObservedObject private var physicsEngine = GameManager.shared.physicsEngine
    
    var body: some View {
        Form {
            // FPS
            HStack(){
                Text("sec/frame: \(gameManager.secondPerFrame)")
                Slider(value: $gameManager.secondPerFrame, in: GameManager.secondPerFrameRange)
            }
            Button(action:{
                let circle = Circle(bodyType: .Dynamic, position: Vector2(500, 300), mass: 10, r: 25)
                gameManager.generateMascot(position: NSPoint(x: 500, y: 500), size: NSSize(width: 50, height: 50), imageFileName: "pachinko_ball", physicsObject: circle)
                circle.addForce(force: Vector2(100, 100))
            }){
                Text("New mascot")
            }
            
            // Physics
            Section(header: Text("Physics")){
                HStack(){
                    Text("Gravity(m/s^2): \(physicsEngine.gravity)")
                    Slider(value: $physicsEngine.gravity, in: Physics2D.gravityRange)
                }
                Text("Objects in engine: \(physicsEngine.objects.count)")
            }
            
            Section(header: Text("Debug")){
                Button(action: {
                    Logger.shared.write(log: getWindowList(.optionAll)!.description)
                }){
                    Text("Debug")
                }
            }
        }
        .padding()
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
