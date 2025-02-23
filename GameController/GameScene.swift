//
//  GameScene.swift
//  SwiftStudentChallege25
//
//  Created by Igor Bragança Toledo on 20/02/25.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    var hexagonsBackground = HexagonsGrid()
    var progressBar = ProgressBar()
    var botController = BotController()
    
    var cameraNode = SKCameraNode()
    var lastCameraPosition: CGPoint?
    var panJustHappened = false
    var didPanCamera = false
    
    var bots: [BotController] = []  // Lista de bots
    var botProgresses: [BotController: CGFloat] = [:]
    
    var initialZoom: CGFloat = 0.4
    var minZoom: CGFloat = 0.4
    var maxZoom: CGFloat = 1.2
    var hexagonSize: CGFloat = 20.0
    var hexGridSize: Int = 10
    
    // ----------- LifeCycle Functions ----------- //
    
    override func didMove(to view: SKView) {
        addChild(hexagonsBackground)
        addChild(botController)
        addChild(cameraNode)
        camera = cameraNode
        
        hexagonsBackground.createHexagons(radius: hexGridSize, size: hexagonSize)
        progressBar.setUpBars(scene: self, hex: hexagonsBackground)
        
        cameraNode.addChild(progressBar)
        cameraNode.setScale(initialZoom)
        calculatePlayerProgress()
        
        if botController.botNodes.isEmpty {
            botController.createBot(hexGrid: hexagonsBackground)
            progressBar.setUpBars(scene: self, hex: hexagonsBackground)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 2
        view.addGestureRecognizer(panGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if didPanCamera {
            print("Toque ignorado porque um pan acabou de acontecer.")
            return
        }
        
        let location = touch.location(in: self)
        
        hexagonsBackground.handleTouch(at: location)
        hexagonsBackground.drawTrail(at: location)
        progressBar.updateProgressBars()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Atualiza as barras de progresso dos bots
        progressBar.updateProgressBars()
        
        // Atualiza o progresso dos bots constantemente
        moveBots()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        hexagonsBackground.drawTrail(at: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hexagonsBackground.finalizeDrawing()
        hexagonsBackground.removeTrail()
        calculatePlayerProgress()
        
        // Atualize o progresso após o toque e a pintura dos hexágonos
        progressBar.updateProgressBars()  // Garantindo que as barras sejam atualizadas após a pintura
        
        let paintedCount = hexagonsBackground.paintedHexagons
        let totalHexagons = hexagonsBackground.totalHexagons
        let filledPercentage = CGFloat(paintedCount) / CGFloat(totalHexagons)
        
        // Atualizando as barras dos bots
        for (index, bot) in botController.botNodes.enumerated() {
            let botHexagons = hexagonsBackground.hexagons.values.filter { $0.fillColor == bot.color }
            let botPaintedCount = botHexagons.count
            let botFilledPercentage = CGFloat(botPaintedCount) / CGFloat(totalHexagons)
        }
        
        print("Atualizando progresso do jogador e bots")
    }
    
    
    func notifyTouchesEnded() {
        touchesEnded(Set<UITouch>(), with: nil)
    }
    
    // ----------- Game Functions ----------- //
    
    func updateBotProgress(for bot: BotController) {
        guard let hexGrid = bot.hex else { return }

        // Calcula a quantidade de hexágonos pintados pelo bot
        let paintedByBot = hexGrid.hexagons.values.filter { $0.fillColor == bot.botNodes.first?.color }.count
        
        // Calcula o total de hexágonos no grid
        let totalHexagons = hexGrid.hexagons.count

        // Calcula o progresso do bot
        let newProgress = min(Double(paintedByBot) / Double(totalHexagons), 1.0)  // Evita ultrapassar 100%
        
        // Atualiza o progresso do bot (certifique-se de que 'botProgresses' seja um dicionário que armazene o progresso de cada bot)
        botProgresses[bot] = newProgress
    }


    func moveBots() {
        for bot in bots {
            // Aqui vai a lógica de movimentação ou expansão do bot
            updateBotProgress(for: bot)  // Atualize o progresso após o movimento/expansão
        }
    }
    
    func calculatePlayerProgress() {
        let totalPlayers = totalPlayers() // Obtém o número total de jogadores e bots
        let totalHexagons = hexagonsBackground.totalHexagons
        let paintedHexagons = hexagonsBackground.paintedHexagons
        
        // Calculando a porcentagem total do mapa pintada
        let paintedPercentage = CGFloat(paintedHexagons) / CGFloat(totalHexagons) * 100
        print("Total de hexágonos pintados: \(paintedHexagons) de \(totalHexagons) (porcentagem: \(paintedPercentage)%)")
        
        // Calculando a porcentagem de cada jogador/bot
        for (index, bot) in botController.botNodes.enumerated() {
            let botHexagons = hexagonsBackground.hexagons.values.filter { $0.fillColor == bot.color }
            let botPaintedCount = botHexagons.count
            let botPercentage = CGFloat(botPaintedCount) / CGFloat(totalHexagons) * 100
            
            print("Bot \(index + 1) pintou \(botPaintedCount) hexágonos (\(botPercentage)%) do total.")
        }
        
        // Para o jogador
        let playerHexagons = hexagonsBackground.hexagons.values.filter { $0.fillColor == hexagonsBackground.playerColor }
        let playerPaintedCount = playerHexagons.count
        let playerPercentage = CGFloat(playerPaintedCount) / CGFloat(totalHexagons) * 100
        
        print("Jogador pintou \(playerPaintedCount) hexágonos (\(playerPercentage)%) do total.")
    }
    
    func totalPlayers() -> Int {
        return botController.botNodes.count + 1
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let view = view else { return }
        
        let translation = recognizer.translation(in: view)
        
        if recognizer.state == .began {
            lastCameraPosition = cameraNode.position
            didPanCamera = true
        } else if recognizer.state == .changed, let lastPosition = lastCameraPosition {
            let newPosition = CGPoint(
                x: lastPosition.x - translation.x,
                y: lastPosition.y + translation.y
            )
            
            if let hexBounds = hexagonsBackground.hexagonBounds ?? nil {
                cameraNode.position = clampCameraPosition(newPosition, within: hexBounds)
            } else {
                cameraNode.position = newPosition
            }
        }
        
        if recognizer.state == .ended || recognizer.state == .cancelled {
            DispatchQueue.main.async {
                self.didPanCamera = false
                self.notifyTouchesEnded()
            }
        }
    }
    
    // ----------- Camera Functions ----------- //
    
    func updateCameraZoom() {
        let paintedCount = hexagonsBackground.paintedHexagonsCount()
        let zoomDecreaseFactor: CGFloat = 0.005
        
        var newScale = initialZoom + (CGFloat(paintedCount) * zoomDecreaseFactor)
        
        newScale = max(minZoom, min(newScale, maxZoom))
        
        let zoomAction = SKAction.scale(to: newScale, duration: 0.3)
        
        cameraNode.run(zoomAction)
        
        hexagonsBackground.updateTrailWidth(forZoom: newScale)
    }
    
    func clampCameraPosition(_ position: CGPoint, within bounds: CGRect) -> CGPoint {
        let cameraHalfWidth = (size.width / 2) / cameraNode.xScale
        let cameraHalfHeight = (size.height / 2) / cameraNode.yScale
        
        let minX = bounds.minX + cameraHalfWidth
        let maxX = bounds.maxX - cameraHalfWidth
        let minY = bounds.minY + cameraHalfHeight
        let maxY = bounds.maxY - cameraHalfHeight
        
        let clampedX = max(minX, min(position.x, maxX))
        let clampedY = max(minY, min(position.y, maxY))
        
        return CGPoint(x: clampedX, y: clampedY)
    }
}
