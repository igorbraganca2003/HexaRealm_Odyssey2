//
//  ContentView.swift
//  SwiftStudentChallege25
//
//  Created by Igor Bragança Toledo on 20/02/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        
        scene.scaleMode = .fill
        scene.backgroundColor = .blue
        
        return scene
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
