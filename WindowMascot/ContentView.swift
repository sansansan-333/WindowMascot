//
//  ContentView.swift
//  WindowMascot
//  
//  Created on 2021/12/30
//  
//

import SwiftUI

struct ContentView: View {
    @State var window: NSWindow?
    
    var body: some View {
        VStack {
            MainView()
                .edgesIgnoringSafeArea(.top)
        }//.background(WindowAccessor(window: $window))
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

/*
// https://stackoverflow.com/questions/63432700/how-to-access-nswindow-from-main-app-using-only-swiftui
struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
            if window != nil{
                transparentizeWindow(window!)
                placeWindowFrontmost(window!)
                GameManager.shared.setWindow(window!)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
 */

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
