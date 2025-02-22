//
//  File.swift
//  HexaRealm_Odyssey2
//
//  Created by Igor Bragança Toledo on 22/02/25.
//

import SpriteKit

class ProgressBar: SKNode {
    
    var gm: GameScene?
    var progressBar: SKShapeNode!
    var progressBarBackground: SKShapeNode!
    
    func setUpBar(scene: GameScene) {
        gm = scene
        
        let progressBarBackgroundSize = CGSize(width: gm!.size.width * 0.9, height: gm!.size.height * 0.05)
        
        // Progress Bar Background
        progressBarBackground = SKShapeNode(rectOf: progressBarBackgroundSize, cornerRadius: 20)
        progressBarBackground.fillColor = .white
        progressBarBackground.strokeColor = .black
        progressBarBackground.lineWidth = 10
        
        progressBarBackground.position = CGPoint(x: 0, y: (gm!.size.height - gm!.size.height) / 2 + 30)
        progressBarBackground.zPosition = 10
        addChild(progressBarBackground)
        
        // Progress Bar
        progressBar = SKShapeNode(rectOf: CGSize(width: 1, height: progressBarBackgroundSize.height), cornerRadius: 20)
        progressBar.fillColor = .purple
        progressBar.strokeColor = .clear
        progressBar.zPosition = 11
        progressBar.setScale(1.0)
        
        addChild(progressBar)
    }
    
    func updateProgressBar(filledPercentage: CGFloat) {
        
        let maxWidth = progressBarBackground.frame.size.width * 0.95
        let scaledWidth = min(maxWidth, maxWidth * filledPercentage)
        
        let newSize = CGSize(width: scaledWidth, height: progressBarBackground.frame.size.height * 0.45)
        let newPath = CGPath(roundedRect: CGRect(origin: .zero, size: newSize), cornerWidth: 8, cornerHeight: 8, transform: nil)
        
        let action = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.progressBar.path = newPath
            
            let verticalCenter = ((self.progressBarBackground.frame.height) - self.progressBar.frame.height * 1.9)
            
            let leftEdgeX = self.progressBarBackground.frame.minX * 0.95
            self.progressBar.position = CGPoint(x: leftEdgeX, y: verticalCenter)
        }
        progressBar.run(action)
    }
}
