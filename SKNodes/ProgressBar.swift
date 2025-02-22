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
        
        // Criando o fundo da barra com bordas pretas e cantos arredondados
        let progressBarBackgroundSize = CGSize(width: gm!.size.width * 0.9, height: 50)
        progressBarBackground = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: progressBarBackgroundSize), cornerRadius: 10)
        progressBarBackground.fillColor = .blue
        progressBarBackground.strokeColor = .black
        progressBarBackground.lineWidth = 3
        
        // Ajustando a posição do fundo para o centro inferior da tela
        progressBarBackground.position = CGPoint(x: gm!.size.width - gm!.size.width, y: 30)
        progressBarBackground.zPosition = 10
        addChild(progressBarBackground)
        
        // Criando a barra de progresso (com cantos arredondados)
        let progressBarSize = CGSize(width: 0, height: progressBarBackgroundSize.height - 4) // Ajuste de altura para deixar a borda visível
        let progressBarPath = CGPath(roundedRect: CGRect(origin: CGPoint.zero, size: progressBarSize), cornerWidth: 8, cornerHeight: 8, transform: nil)
        progressBar = SKShapeNode(path: progressBarPath)
        progressBar.fillColor = .purple
        
        // Ajustando a posição da barra para que fique centralizada dentro do fundo
        progressBar.position = CGPoint(x: progressBarBackground.position.x - progressBarBackground.frame.size.width / 2, y: progressBarBackground.position.y)
        progressBar.zPosition = 11
        addChild(progressBar)
    }
    
    func updateProgressBar(filledPercentage: CGFloat) {
        let maxWidth = progressBarBackground.frame.size.width - 4 // Considerando a borda
        let newWidth = maxWidth * filledPercentage
        let newSize = CGSize(width: newWidth, height: progressBar.frame.size.height)
        
        // Atualizando o path da barra de progresso para o novo tamanho
        let newPath = CGPath(roundedRect: CGRect(origin: CGPoint.zero, size: newSize), cornerWidth: 8, cornerHeight: 8, transform: nil)
        let action = SKAction.customAction(withDuration: 0.2) { [weak self] node, _ in
            guard let self = self else { return }
            self.progressBar.path = newPath
        }
        
        progressBar.run(action)
    }
}
