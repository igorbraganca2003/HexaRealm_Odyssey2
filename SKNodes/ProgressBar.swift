//
//  File.swift
//  HexaRealm_Odyssey2
//
//  Created by Igor Bragança Toledo on 22/02/25.
//

import SpriteKit
import SwiftUI

class ProgressBar: SKNode {
    var gm: GameScene?
    var hexGrid: HexagonsGrid?
    var progressBars: [SKShapeNode] = []
    let barHeight: CGFloat = 20
    let totalWidth: CGFloat = 400 // Largura total da barra de progresso

    func setUpBars(scene: GameScene, hex: HexagonsGrid) {
        gm = scene
        hexGrid = hex
        
        let totalPlayers = scene.totalPlayers()
        let startX = -totalWidth / 2
        let initialWidth = totalWidth / CGFloat(totalPlayers) // Começa dividido igualmente

        // Remover barras antigas
        progressBars.forEach { $0.removeFromParent() }
        progressBars.removeAll()
        
        var currentX = startX
        for i in 0..<totalPlayers {
            let progressBar = SKShapeNode()
            progressBar.fillColor = i == 0 ? hex.playerColor : gm!.botController.botNodes[i - 1].color
            progressBar.strokeColor = .black
            progressBar.zPosition = 10
            
            let path = CGMutablePath()
            path.addRect(CGRect(x: 0, y: -barHeight / 2, width: initialWidth, height: barHeight))
            progressBar.path = path
            progressBar.position = CGPoint(x: currentX + initialWidth / 2, y: 0) // Ajuste correto
            
            addChild(progressBar)
            progressBars.append(progressBar)
            currentX += initialWidth
        }
    }
    
    func updateProgressBars() {
        guard let hexGrid = hexGrid, let gm = gm else { return }
        
        let totalHexagons = CGFloat(hexGrid.hexagons.count)
        guard totalHexagons > 0 else { return }

        var playerCounts: [CGFloat] = Array(repeating: 0, count: progressBars.count)
        
        // Contagem de hexágonos por jogador/bot
        for hex in hexGrid.hexagons.values {
            if hex.fillColor == hexGrid.playerColor {
                playerCounts[0] += 1
            } else {
                for (index, bot) in gm.botController.botNodes.enumerated() {
                    if hex.fillColor == bot.color {
                        playerCounts[index + 1] += 1
                    }
                }
            }
        }
        
        let totalPainted = playerCounts.reduce(0, +)
        if totalPainted == 0 { return }
        
        let startX = -totalWidth / 2
        var currentX = startX
        
        for (i, progressBar) in progressBars.enumerated() {
            let percentage = playerCounts[i] / totalHexagons
            let barWidth = max(1, totalWidth * percentage) // Evita largura 0
            
            if barWidth > 0 {
                progressBar.isHidden = false
                
                // **IMPORTANTE: recriar o path para que a largura seja alterada**
                let newPath = CGMutablePath()
                newPath.addRect(CGRect(x: 0, y: -barHeight / 2, width: barWidth, height: barHeight))
                progressBar.path = newPath
                
                progressBar.position = CGPoint(x: currentX + barWidth / 2, y: 0) // Mantém a posição correta
                currentX += barWidth
            } else {
                progressBar.isHidden = true
            }
        }
    }
}
