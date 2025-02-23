//
//  BotController.swift
//  HexaRealm_Odyssey2
//
//  Created by Igor Bragança Toledo on 23/02/25.
//

import SpriteKit

class BotController: SKNode {
    
    var hex: HexagonsGrid?
    var botNodes: [(node: SKShapeNode, color: UIColor)] = []
    var botTimers: [Timer] = []
    
    var progressBar: ProgressBar?
    
    func createBot(hexGrid: HexagonsGrid) {
        hex = hexGrid
        
        let botPositions: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 100, y: 100),
            CGPoint(x: -100, y: -100)
        ]
        
        let botColors: [UIColor] = [.green, .blue, .red]
        
        for (index, position) in botPositions.enumerated() {
            if let nearestHexagon = findNearestHexagon(to: position, in: hexGrid) {
                paintHexagon(nearestHexagon, color: botColors[index])
                botNodes.append((node: nearestHexagon, color: botColors[index]))
                
                let fixedSpeed: TimeInterval = 1.2
                startBotExpansion(botIndex: index, speed: fixedSpeed)
            }
        }
    }
    
    func findNearestHexagon(to position: CGPoint, in hexGrid: HexagonsGrid) -> SKShapeNode? {
        return hexGrid.hexagons.min { $0.key.distance(to: position) < $1.key.distance(to: position) }?.value
    }
    
    func paintHexagon(_ hexagon: SKShapeNode, color: UIColor) {
        hexagon.fillColor = color
        hex?.paintedHexagons += 1
    }
    
    func startBotExpansion(botIndex: Int, speed: TimeInterval) {
        let timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if botIndex >= self.botNodes.count {
                    print("Bot \(botIndex) já foi eliminado, parando expansão.")
                    return
                }
                
                self.expandBotArea(botIndex: botIndex)
            }
        }
        botTimers.append(timer)
    }
    
    func expandBotArea(botIndex: Int) {
        guard let hexGrid = hex, botIndex < botNodes.count else { return }

        let bot = botNodes[botIndex]

        let botHexagons = hexGrid.hexagons.values.filter { $0.fillColor == bot.color }
        
        // Verifica se o bot ainda tem hexágonos para expandir
        if botHexagons.isEmpty {
            eliminateBot(botIndex: botIndex)
            return
        }

        print("Bot \(botIndex) expandindo...")

        var newHexagons: [SKShapeNode] = []
        
        for hex in botHexagons {
            let possibleNeighbors = hexGrid.hexagons.filter { (position, neighborHex) in
                return (neighborHex.fillColor == .white || neighborHex.fillColor != bot.color) &&
                       position.distance(to: hex.position) < hexGrid.hexagonSize * 2
            }.map { $0.value }
            
            if !possibleNeighbors.isEmpty {
                let randomHex = possibleNeighbors.randomElement()!
                newHexagons.append(randomHex)
            }
        }
        
        for hex in newHexagons {
            paintHexagon(hex, color: bot.color)
        }
        
        // Atualiza os indicadores de bots na progress bar após a expansão
//        if let gameScene = scene as? GameScene {
//            gameScene.updateBotProgress()
//        }
        
        // Verifica se o bot foi completamente cercado pelo jogador ou outro bot
        if isBotEliminated(botIndex: botIndex) {
            eliminateBot(botIndex: botIndex)
        }
    }

    func isBotEliminated(botIndex: Int) -> Bool {
        guard let hexGrid = hex else { return false }
        
        let bot = botNodes[botIndex]
        
        // Verifica se todos os hexágonos do bot foram pintados por outro bot ou o jogador
        let botHexagons = hexGrid.hexagons.values.filter { $0.fillColor == bot.color }
        
        return botHexagons.isEmpty
    }

    func eliminateBot(botIndex: Int) {
        guard botIndex < botNodes.count else { return }
        
        print("Bot \(botIndex) foi eliminado!")

        if botIndex < botTimers.count {
            botTimers[botIndex].invalidate()
            botTimers.remove(at: botIndex)
        }

        botNodes.remove(at: botIndex)
    }
}
