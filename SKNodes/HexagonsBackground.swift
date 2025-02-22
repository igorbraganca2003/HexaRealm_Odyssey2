//
//  HexagonsBackground.swift
//  SwiftStudentChallege25
//
//  Created by Igor Bragança Toledo on 20/02/25.
//

import SpriteKit
import CoreGraphics


class HexagonsBackground: SKNode {
    
    var trailPath: CGMutablePath = CGMutablePath()
    var trailNode: SKShapeNode?
    var paintedHexagons = 0
    
    var hexagons: [CGPoint: SKShapeNode] = [:]
    var hexagonSize: CGFloat = 20.0
    
    func createHexagonalGrid(radius: Int, size: CGFloat) {
        for q in -radius...radius {
            for r in max(-radius, -q - radius)...min(radius, -q + radius) {
                let x = CGFloat(q) * size * 1.5
                let y = CGFloat(r) * size * sqrt(3) + (CGFloat(q) * size * sqrt(3) / 2 )
                
                let hexagon = SKShapeNode(path: createHexagonPath(size: size))
                hexagon.position = CGPoint(x: x, y: y)
                hexagon.strokeColor = .black
                hexagon.fillColor = .clear
                addChild(hexagon)
            }
        }
    }
    
    func createHexagons(radius: Int, size: CGFloat) {
        for q in -radius...radius {
            for r in max(-radius, -q - radius)...min(radius, -q + radius) {
                let x = CGFloat(q) * size * 1.5
                let y = CGFloat(r) * size * sqrt(3) + (CGFloat(q) * size * sqrt(3) / 2)
                
                let hexagon = createHexagon(size: size)
                hexagon.position = CGPoint(x: x, y: y)
                hexagon.name = "hexagon"
                addChild(hexagon)
                hexagons[hexagon.position] = hexagon
            }
        }
    }
    
    func createHexagonPath(size: CGFloat) -> CGPath {
        let path = UIBezierPath()
        for i in 0..<6 {
            let angle = CGFloat(i) * (.pi / 3)
            let point = CGPoint(x: cos(angle) * size, y: sin(angle) * size)
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        return path.cgPath
    }
    
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
                let x = CGFloat(col) * 1.5 * size
                let y = CGFloat(row) * height
                
                var hexPosition = CGPoint(x: x, y: y)
                
                if col % 2 != 0 {
                    hexPosition.y -= height / 2
                }
                
                let hexagon = createHexagon(size: size)
                hexagon.position = hexPosition
                hexagon.name = "hexagon"
                addChild(hexagon)
                hexagons[hexPosition] = hexagon
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
        
        if let gameScene = scene as? GameScene {
            updateTrailWidth(forZoom: gameScene.cameraNode.xScale)
        }
    }
    
    func paintHexagonsInsideTrail() {
        for (_, hexagon) in hexagons {
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
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}

