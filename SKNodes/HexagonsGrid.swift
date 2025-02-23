//
//  HexagonsBackground.swift
//  SwiftStudentChallege25
//
//  Created by Igor Bragança Toledo on 20/02/25.
//

import SpriteKit

class HexagonsGrid: SKNode {
    
    var trailPath: CGMutablePath = CGMutablePath()
    var trailNode: SKShapeNode?
    var paintedHexagons = 0
    var totalHexagons = 0
    
    var hexagons: [CGPoint: SKShapeNode] = [:]
    var hexagonSize: CGFloat = 20.0
    var hexagonBounds: CGRect = .zero
    var hexColor: UIColor = .yellow
    var playerColor: UIColor = .orange
    
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
        var minX: CGFloat = .greatestFiniteMagnitude
        var maxX: CGFloat = -.greatestFiniteMagnitude
        var minY: CGFloat = .greatestFiniteMagnitude
        var maxY: CGFloat = -.greatestFiniteMagnitude

        for q in -radius...radius {
            for r in max(-radius, -q - radius)...min(radius, -q + radius) {
                let x = CGFloat(q) * size * 1.5
                let y = CGFloat(r) * size * sqrt(3) + (CGFloat(q) * size * sqrt(3) / 2)

                minX = min(minX, x)
                maxX = max(maxX, x)
                minY = min(minY, y)
                maxY = max(maxY, y)

                let hexagon = createHexagon(size: size)
                hexagon.position = CGPoint(x: x, y: y)
                addChild(hexagon)
                hexagons[hexagon.position] = hexagon
                totalHexagons += 1 
            }
        }

        let padding: CGFloat = 50
        hexagonBounds = CGRect(x: minX - padding, y: minY - padding,
                               width: (maxX - minX) + 2 * padding,
                               height: (maxY - minY) + 2 * padding)
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
    
    func getHexagonAt(location: CGPoint) -> SKShapeNode? {
        return nodes(at: location).compactMap { $0 as? SKShapeNode }.first
    }
    
    func paintHexagon(_ hexagon: SKShapeNode, color: UIColor) {
        if hexagon.fillColor != playerColor {
            hexagon.fillColor = playerColor
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
            paintHexagon(hexagon, color: hexColor)
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
                paintHexagon(hexagon, color: hexColor)
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
