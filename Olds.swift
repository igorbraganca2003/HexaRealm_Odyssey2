//
//  Olds.swift
//  HexaRealm_Odyssey2
//
//  Created by Igor Bragança Toledo on 23/02/25.
//

//    func createHexagons(columns: Int, rows: Int, size: CGFloat) {
//        let width = 2 * size
//        let height = sqrt(3) * size
//
//        for row in 0..<rows {
//            for col in 0..<columns {
//                let x = CGFloat(col) * 1.5 * size
//                let y = CGFloat(row) * height
//
//                var hexPosition = CGPoint(x: x, y: y)
//
//                if col % 2 != 0 {
//                    hexPosition.y -= height / 2
//                }
//
//                let hexagon = createHexagon(size: size)
//                hexagon.position = hexPosition
//                hexagon.name = "hexagon"
//                addChild(hexagon)
//                hexagons[hexPosition] = hexagon
//            }
//        }
//    }





//class ProgressBar: SKNode {
//
//    var gm: GameScene?
//    var hexGrid: HexagonsGrid?
//    var progressBars: [SKShapeNode] = []
//    var progressBarBackgrounds: [SKShapeNode] = []
//    let maxBarWidth: CGFloat = 300 // Largura máxima de cada barra
//    let barHeight: CGFloat = 20    // Altura fixa das barras
//
//    func setUpBar(scene: GameScene, hex: HexagonsGrid) {
//        gm = scene
//        hexGrid = hex
//
//        let totalBars = 1 + gm!.botController.botNodes.count // 1 para o jogador + bots
//        let totalSpacing: CGFloat = 20.0 // Espaçamento entre as barras
//        let totalWidth = CGFloat(totalBars) * maxBarWidth + CGFloat(totalBars - 1) * totalSpacing
//
//        // Configura a posição inicial
//        let startingX = -(totalWidth / 2) + maxBarWidth / 2
//
//        // Barra do jogador
//        for i in 0..<totalBars {
//            let progressBarBackgroundSize = CGSize(width: maxBarWidth, height: barHeight)
//            let progressBarBackground = SKShapeNode(rectOf: progressBarBackgroundSize, cornerRadius: 10)
//            progressBarBackground.fillColor = .white
//            progressBarBackground.strokeColor = .black
//            progressBarBackground.lineWidth = 4
//            progressBarBackground.position = CGPoint(x: startingX + CGFloat(i) * (maxBarWidth + totalSpacing), y: -gm!.size.height / 2 + 30)
//            progressBarBackground.zPosition = 10
//            addChild(progressBarBackground)
//            progressBarBackgrounds.append(progressBarBackground)
//
//            let progressBar = SKShapeNode(rectOf: CGSize(width: 1, height: progressBarBackgroundSize.height), cornerRadius: 10)
//            progressBar.strokeColor = .clear
//            progressBar.zPosition = 11
//            progressBar.setScale(1.0)
//
//            // Definir a cor da barra com base no jogador ou bot
//            if i == 0 {
//                progressBar.fillColor = hex.playerColor // Cor do jogador
//            } else {
//                progressBar.fillColor = gm!.botController.botNodes[i - 1].color // Cor do bot
//            }
//
//            addChild(progressBar)
//            progressBars.append(progressBar)
//        }
//    }
//
//    func createProgressBar(at xPosition: CGFloat, isPlayer: Bool, index: Int, botColor: UIColor? = nil) {
//        let progressBarBackgroundSize = CGSize(width: maxBarWidth, height: barHeight)
//        let progressBarBackground = SKShapeNode(rectOf: progressBarBackgroundSize, cornerRadius: 10)
//        progressBarBackground.fillColor = .white
//        progressBarBackground.strokeColor = .black
//        progressBarBackground.lineWidth = 4
//        progressBarBackground.position = CGPoint(x: xPosition, y: -gm!.size.height / 2 + 30)
//        progressBarBackground.zPosition = 11
//        addChild(progressBarBackground)
//        progressBarBackgrounds.append(progressBarBackground)
//
//        // Definir a cor da barra com base no jogador ou bot
//        let progressBar = SKShapeNode(rectOf: CGSize(width: 1, height: progressBarBackgroundSize.height), cornerRadius: 10)
//        progressBar.strokeColor = .clear
//        progressBar.zPosition = 11
//        progressBar.setScale(1.0)
//
//        // Se for o jogador, use uma cor fixa, se for o bot, use a cor correspondente
//        if isPlayer {
//            progressBar.fillColor = .purple // Cor do jogador
//        } else {
//            progressBar.fillColor = botColor ?? .purple // Cor do bot, com fallback se necessário
//        }
//
//        addChild(progressBar)
//        progressBars.append(progressBar)
//    }
//
//    func updateProgressBar(filledPercentage: CGFloat, botIndex: Int) {
//        let progressBar = progressBars[botIndex]
//        let progressBarBackground = progressBarBackgrounds[botIndex]
//
//        // Definir a largura fixa de cada barra
//        let barWidth = progressBarBackground.frame.size.width
//
//        // Calculando a largura da barra de progresso com base na porcentagem
//        let maxWidth = progressBarBackgrounds[botIndex].frame.size.width
//        let scaledWidth = min(maxWidth, maxWidth * filledPercentage)
//
//        let newSize = CGSize(width: scaledWidth, height: progressBarBackground.frame.size.height * 0.45)
//        let newPath = CGPath(roundedRect: CGRect(origin: .zero, size: newSize), cornerWidth: 8, cornerHeight: 8, transform: nil)
//
//        let action = SKAction.run { [weak self] in
//            guard let self = self else { return }
//
//            // Atualizando a barra de progresso
//            progressBar.path = newPath
//
//            // A posição agora é baseada apenas no índice, sem depender das outras barras
//            let barSpacing: CGFloat = 10 // Espaço entre as barras
//            let barWidth = progressBarBackground.frame.size.width * 0.3 // Largura de cada barra de progresso (30% da largura da barra total)
//
//            // Calcula o deslocamento da barra baseada no índice (em X)
//            let xOffset = CGFloat(botIndex) * (barWidth + barSpacing) - progressBarBackground.frame.size.width / 2
//
//            // Atualizando a posição da barra para ela ser colocada lado a lado
//            progressBar.position = CGPoint(x: xOffset, y: 0)
//        }
//        progressBar.run(action)
//    }
//}





//
//import SpriteKit
//import SwiftUI
//
//class GameScene: SKScene {
//
//    var hexagonsBackground = HexagonsGrid()
//    var progressBar = ProgressBar()
//    var botController = BotController()
//
//    var cameraNode = SKCameraNode()
//    var lastCameraPosition: CGPoint?
//    var panJustHappened = false
//    var didPanCamera = false
//
//    var initialZoom: CGFloat = 0.4
//    var minZoom: CGFloat = 0.4
//    var maxZoom: CGFloat = 1.2
//    var hexagonSize: CGFloat = 20.0
//    var hexGridSize: Int = 10
//
//    override func didMove(to view: SKView) {
//        addChild(hexagonsBackground)
//        addChild(botController)
//        addChild(cameraNode)
//        camera = cameraNode
//
//        hexagonsBackground.createHexagons(radius: hexGridSize, size: hexagonSize)
//        progressBar.setUpBars(scene: self, hex: hexagonsBackground)
//
//        // Garante que o BotController não seja recriado desnecessariamente
//        if botController.botNodes.isEmpty {
//            botController.createBot(hexGrid: hexagonsBackground)
//        }
//
////        progressBar.setUpBar(scene: self, hex: hexagonsBackground)
//        cameraNode.addChild(progressBar)
//
//        cameraNode.setScale(initialZoom)
//
////        positionProgressBar()
//
//        calculatePlayerProgress()
//
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        panGesture.minimumNumberOfTouches = 2
//        view.addGestureRecognizer(panGesture)
//    }
//
//    func calculatePlayerProgress() {
//        let totalPlayers = totalPlayers() // Obtém o número total de jogadores e bots
//        let totalHexagons = hexagonsBackground.totalHexagons
//        let paintedHexagons = hexagonsBackground.paintedHexagons
//
//        // Calculando a porcentagem total do mapa pintada
//        let paintedPercentage = CGFloat(paintedHexagons) / CGFloat(totalHexagons) * 100
//        print("Total de hexágonos pintados: \(paintedHexagons) de \(totalHexagons) (porcentagem: \(paintedPercentage)%)")
//
//        // Calculando a porcentagem de cada jogador/bot
//        for (index, bot) in botController.botNodes.enumerated() {
//            let botHexagons = hexagonsBackground.hexagons.values.filter { $0.fillColor == bot.color }
//            let botPaintedCount = botHexagons.count
//            let botPercentage = CGFloat(botPaintedCount) / CGFloat(totalHexagons) * 100
//
//            print("Bot \(index + 1) pintou \(botPaintedCount) hexágonos (\(botPercentage)%) do total.")
//        }
//
//        // Para o jogador
//        let playerHexagons = hexagonsBackground.hexagons.values.filter { $0.fillColor == hexagonsBackground.playerColor }
//        let playerPaintedCount = playerHexagons.count
//        let playerPercentage = CGFloat(playerPaintedCount) / CGFloat(totalHexagons) * 100
//
//        print("Jogador pintou \(playerPaintedCount) hexágonos (\(playerPercentage)%) do total.")
//    }
//
//
//
//    func totalPlayers() -> Int {
//        return botController.botNodes.count + 1 // Adiciona 1 para o jogador
//    }
//
////    func updatePlayerProgress() {
////        let totalHexagons = hexagonsBackground.totalHexagons
////        let paintedCount = hexagonsBackground.paintedHexagonsCount()
////        let filledPercentage = CGFloat(paintedCount) / CGFloat(totalHexagons)
////
////        // Atualizando a barra de progresso do jogador (índice 0)
//////        progressBar.updateProgressBar(filledPercentage: filledPercentage, botIndex: 0)
////    }
//
////    func updateBotProgress() {
////        let totalHexagons = hexagonsBackground.totalHexagons
////        let totalPlayersCount = totalPlayers() // Obtém o total de jogadores (bot + jogador)
////
////        // Atualizando as barras de progresso dos bots
////        for (index, bot) in botController.botNodes.enumerated() {
////            let botHexagons = hexagonsBackground.hexagons.values.filter { $0.fillColor == bot.color }
////            let botPaintedCount = botHexagons.count
////            let botFilledPercentage = CGFloat(botPaintedCount) / CGFloat(totalHexagons)
////
////            // Atualizando a barra de progresso de cada bot
//////            progressBar.updateProgressBar(filledPercentage: botFilledPercentage, botIndex: index + 1) // Começar de 1 para o primeiro bot
////        }
////
////        // Atualizando a barra de progresso do jogador (índice 0)
////        updatePlayerProgress()
////    }
//
//
////    func updatePlayerProgress() {
////        let totalHexagons = hexagonsBackground.totalHexagons
////        let paintedCount = hexagonsBackground.paintedHexagonsCount()
////        let filledPercentage = CGFloat(paintedCount) / CGFloat(totalHexagons)
////
////        // Atualizando a barra de progresso do jogador
////        progressBar.updateProgressBar(filledPercentage: filledPercentage, botIndex: 0)
////    }
////
////    func positionProgressBar() {
////        guard let scene = scene else { return }
////        let offsetY: CGFloat = 50
////
////        progressBar.position = CGPoint(
////            x: cameraNode.position.x,
////            y: cameraNode.position.y - scene.size.height / 2 + offsetY
////        )
////
////    }
////
////    func updateBotProgress() {
////        let totalHexagons = hexagonsBackground.totalHexagons
////
////        // Atualizando as barras de progresso dos bots
////        for (index, bot) in botController.botNodes.enumerated() {
////            let botHexagons = hexagonsBackground.hexagons.values.filter { $0.fillColor == bot.color }
////            let botPaintedCount = botHexagons.count
////            let botFilledPercentage = CGFloat(botPaintedCount) / CGFloat(totalHexagons)
////
////            // Atualizando a barra de progresso de cada bot
////            progressBar.updateProgressBar(filledPercentage: botFilledPercentage, botIndex: index + 1) // Começar de 1 para o primeiro bot
////        }
////    }
//
//    func updateCameraZoom() {
//        let paintedCount = hexagonsBackground.paintedHexagonsCount()
//        let zoomDecreaseFactor: CGFloat = 0.005
//
//        var newScale = initialZoom + (CGFloat(paintedCount) * zoomDecreaseFactor)
//
//        newScale = max(minZoom, min(newScale, maxZoom))
//
//        let zoomAction = SKAction.scale(to: newScale, duration: 0.3)
//
//        cameraNode.run(zoomAction)
//
//        hexagonsBackground.updateTrailWidth(forZoom: newScale)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//
//        if didPanCamera {
//            print("Toque ignorado porque um pan acabou de acontecer.")
//            return
//        }
//
//        let location = touch.location(in: self)
//
//        hexagonsBackground.handleTouch(at: location)
//        hexagonsBackground.drawTrail(at: location)
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//
//        hexagonsBackground.drawTrail(at: location)
//
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        hexagonsBackground.finalizeDrawing()
//        hexagonsBackground.removeTrail()
////        updateBotProgress()
////        updatePlayerProgress()
//        calculatePlayerProgress()
//
//        let paintedCount = hexagonsBackground.paintedHexagons
//        let totalHexagons = hexagonsBackground.totalHexagons
//        let filledPercentage = CGFloat(paintedCount) / CGFloat(totalHexagons)
//
//        // Atualizando a barra de progresso do jogador
////        progressBar.updateProgressBar(filledPercentage: filledPercentage, botIndex: 0)
//
//        // Atualizando as barras dos bots
//        for (index, bot) in botController.botNodes.enumerated() {
//            let botHexagons = hexagonsBackground.hexagons.values.filter { $0.fillColor == bot.color }
//            let botPaintedCount = botHexagons.count
//            let botFilledPercentage = CGFloat(botPaintedCount) / CGFloat(totalHexagons)
//
//            // Atualizando a barra de progresso de cada bot
////            progressBar.updateProgressBar(filledPercentage: botFilledPercentage, botIndex: index + 1) // Começar de 1 para o primeiro bot
//        }
//
//        print("Atualizando progresso do jogador e bots")
////        updatePlayerProgress()
////        updateBotProgress()
//
//    }
//
//    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
//        guard let view = view else { return }
//
//        let translation = recognizer.translation(in: view)
//
//        if recognizer.state == .began {
//            lastCameraPosition = cameraNode.position
//            didPanCamera = true
//        } else if recognizer.state == .changed, let lastPosition = lastCameraPosition {
//            let newPosition = CGPoint(
//                x: lastPosition.x - translation.x,
//                y: lastPosition.y + translation.y
//            )
//
//            if let hexBounds = hexagonsBackground.hexagonBounds ?? nil {
//                cameraNode.position = clampCameraPosition(newPosition, within: hexBounds)
//            } else {
//                cameraNode.position = newPosition
//            }
//        }
//
//        if recognizer.state == .ended || recognizer.state == .cancelled {
//            DispatchQueue.main.async {
//                self.didPanCamera = false
//                self.notifyTouchesEnded()
//            }
//        }
//    }
//
//    func clampCameraPosition(_ position: CGPoint, within bounds: CGRect) -> CGPoint {
//        let cameraHalfWidth = (size.width / 2) / cameraNode.xScale
//        let cameraHalfHeight = (size.height / 2) / cameraNode.yScale
//
//        let minX = bounds.minX + cameraHalfWidth
//        let maxX = bounds.maxX - cameraHalfWidth
//        let minY = bounds.minY + cameraHalfHeight
//        let maxY = bounds.maxY - cameraHalfHeight
//
//        let clampedX = max(minX, min(position.x, maxX))
//        let clampedY = max(minY, min(position.y, maxY))
//
//        return CGPoint(x: clampedX, y: clampedY)
//    }
//
//    func notifyTouchesEnded() {
//        touchesEnded(Set<UITouch>(), with: nil)
//    }
//}
