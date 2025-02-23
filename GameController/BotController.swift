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
    
    func createBot(hexGrid: HexagonsGrid) {
        hex = hexGrid
        
        // Posições iniciais para os bots
        let botPositions: [CGPoint] = [
            CGPoint(x: 0, y: 0),      // Centro
            CGPoint(x: 100, y: 100),  // Canto superior direito
            CGPoint(x: -100, y: -100) // Canto inferior esquerdo
        ]
        
        // Cores únicas para cada bot
        let botColors: [UIColor] = [.green, .blue, .red]
        
        for (index, position) in botPositions.enumerated() {
            if let nearestHexagon = findNearestHexagon(to: position, in: hexGrid) {
                paintHexagon(nearestHexagon, color: botColors[index])
                botNodes.append((node: nearestHexagon, color: botColors[index]))
                
                // Inicia a expansão do bot com um intervalo específico
                startBotExpansion(botIndex: index, speed: 1.0 + Double(index) * 0.5)
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

        // Se o bot não tem mais hexágonos, ele deve ser eliminado
        let botHexagons = hexGrid.hexagons.values.filter { $0.fillColor == bot.color }
        if botHexagons.isEmpty {
            eliminateBot(botIndex: botIndex)
            return
        }

        print("Bot \(botIndex) expandindo...")

        var newHexagons: [SKShapeNode] = []
        
        // Expansão: Encontra hexágonos vizinhos que podem ser pintados
        for hex in botHexagons {
            for (position, neighborHex) in hexGrid.hexagons {
                if (neighborHex.fillColor == .white || neighborHex.fillColor != bot.color) &&
                    position.distance(to: hex.position) < hexGrid.hexagonSize * 2 {
                    newHexagons.append(neighborHex)
                }
            }
        }
        
        for hex in newHexagons {
            paintHexagon(hex, color: bot.color)
        }
    }
    
    func eliminateBot(botIndex: Int) {
        guard botIndex < botNodes.count else { return }
        
        print("Bot \(botIndex) foi eliminado!")

        // Para o timer do bot
        if botIndex < botTimers.count {
            botTimers[botIndex].invalidate()
            botTimers.remove(at: botIndex)
        }

        // Remove o bot da lista
        botNodes.remove(at: botIndex)
    }
}
