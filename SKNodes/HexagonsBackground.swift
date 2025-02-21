//
//  HexagonsBackground.swift
//  SwiftStudentChallege25
//
//  Created by Igor Bragança Toledo on 20/02/25.
//

import SpriteKit

class HexagonsBackground: SKNode {
    
    var hexagons: [SKShapeNode] = []
    var trailPath: CGMutablePath = CGMutablePath()
    var trailNode: SKShapeNode?
    var paintedHexagons = 5
    
    func createHexagon(size: CGFloat) -> SKShapeNode {
        let path = UIBezierPath()
        for i in 0..<6 {
            let angle = CGFloat(i) * (CGFloat.pi / 3)
            let point = CGPoint(x: size * cos(angle), y: size * sin(angle))
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        
        let hexagon = SKShapeNode(path: path.cgPath)
        hexagon.strokeColor = .lightGray
        hexagon.fillColor = .white
        hexagon.lineWidth = 3
        
        return hexagon
    }
    
    func createHexagons(columns: Int, rows: Int, size: CGFloat) {
        let width = 2 * size
        let height = sqrt(3) * size
        
        for row in 0..<rows {
            for col in 0..<columns {
                let hexagon = createHexagon(size: size)
                
                let x = CGFloat(col) * 1.5 * size
                let y = CGFloat(row) * height
                
                if col % 2 != 0 {
                    hexagon.position = CGPoint(x: x, y: y - (height / 2))
                } else {
                    hexagon.position = CGPoint(x: x, y: y)
                }
                
                hexagon.name = "hexagon"
                addChild(hexagon)
                hexagons.append(hexagon)
            }
        }
    }
    
    func getHexagonAt(location: CGPoint) -> SKShapeNode? {
        return nodes(at: location).compactMap { $0 as? SKShapeNode }.first
    }
    
    func paintHexagon(_ hexagon: SKShapeNode) {
        if hexagon.fillColor != .orange {
            hexagon.fillColor = .orange
            paintedHexagons += 1
            
            if let gameScene = scene as? GameScene {
                gameScene.updateCameraZoom()
            }
        }
    }
    
    func paintedHexagonsCount() -> Int {
        return paintedHexagons
    }
    
    func handleTouch(at location: CGPoint) {
        if let hexagon = getHexagonAt(location: location) {
            paintHexagon(hexagon)
        }
    }
    
    func updateTrailWidth(forZoom zoom: CGFloat) {
        trailNode?.lineWidth = 10 * zoom
    }
    
    func drawTrail(at location: CGPoint) {
        if trailNode == nil {
            trailNode = SKShapeNode()
            trailNode?.strokeColor = UIColor.blue.withAlphaComponent(0.5)
            trailNode?.lineWidth = 10
            trailNode?.zPosition = 1
            addChild(trailNode!)
        }
        
        if trailPath.isEmpty {
            trailPath.move(to: location)
        } else {
            trailPath.addLine(to: location)
        }
        
        trailNode?.path = trailPath
        
        // Ajustar a espessura do rastro conforme o zoom
        if let gameScene = scene as? GameScene {
            updateTrailWidth(forZoom: gameScene.cameraNode.xScale)
        }
    }
    
    
    func paintHexagonsInsideTrail() {
        for hexagon in hexagons {
            if trailPath.contains(hexagon.position) {
                paintHexagon(hexagon)
            }
        }
    }
    
    func finalizeDrawing() {
        paintHexagonsInsideTrail()
    }
    
    func removeTrail() {
        trailPath = CGMutablePath()
        trailNode?.removeFromParent()
        trailNode = nil
    }
    
    func paintInitialHexagons() {
        guard hexagons.count > 0 else { return }
        
        let centerIndex = hexagons.count / 2
        
        let initialHexagons = [
            centerIndex,
            max(centerIndex - 1, 0)
        ]
        
        for index in initialHexagons {
            paintHexagon(hexagons[index])
        }
    }
}
