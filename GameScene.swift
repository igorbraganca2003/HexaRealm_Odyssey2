//
//  GameScene.swift
//  SwiftStudentChallege25
//
//  Created by Igor Bragança Toledo on 20/02/25.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    var hexagonsBackground = HexagonsBackground()
    var cameraNode = SKCameraNode()
    
    // Propriedades para configurar zoom
    var initialZoom: CGFloat = 1.0
    var minZoom: CGFloat = 0.5
    var maxZoom: CGFloat = 5.0
    
    // Tamanho do hexágono e quantidade de colunas/linhas
    var hexagonSize: CGFloat = 20.0
    var columns: Int = 100
    var rows: Int = 100
    
    override func didMove(to view: SKView) {
        addChild(hexagonsBackground)
        
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cameraNode)
        camera = cameraNode
        
        // Criar os hexágonos com base nas novas propriedades
        hexagonsBackground.createHexagons(columns: columns, rows: rows, size: hexagonSize)
        hexagonsBackground.paintInitialHexagons()
        
        // Definir o zoom inicial
        cameraNode.setScale(initialZoom)
    }
    
    func updateCameraZoom() {
        let baseScale: CGFloat = initialZoom
        let zoomFactor: CGFloat = 0.0009
        
        let paintedCount = hexagonsBackground.paintedHexagonsCount()
        var newScale = max(minZoom, baseScale + (CGFloat(paintedCount) * zoomFactor))
        
        newScale = min(max(newScale, minZoom), maxZoom)
        
        let zoomAction = SKAction.scale(to: newScale, duration: 0.3)
        cameraNode.run(zoomAction)
        
        // Atualizar a espessura do rastro para manter a visibilidade correta
        hexagonsBackground.updateTrailWidth(forZoom: newScale)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        hexagonsBackground.handleTouch(at: location)
        hexagonsBackground.drawTrail(at: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        hexagonsBackground.drawTrail(at: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hexagonsBackground.finalizeDrawing()
        hexagonsBackground.removeTrail()
    }
}
