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
    
    var initialZoom: CGFloat = 0.4
    var minZoom: CGFloat = 0.4
    var maxZoom: CGFloat = 1.2
    var hexagonSize: CGFloat = 20.0
    var hexGridSize: Int = 5
    
    override func didMove(to view: SKView) {
        addChild(hexagonsBackground)
        addChild(botController)
        addChild(cameraNode)
        camera = cameraNode
        
        hexagonsBackground.createHexagons(radius: hexGridSize, size: hexagonSize)
        
        // Garante que o BotController não seja recriado desnecessariamente
        if botController.botNodes.isEmpty {
            botController.createBot(hexGrid: hexagonsBackground)
        }

        progressBar.setUpBar(scene: self)
        cameraNode.addChild(progressBar)
        
        cameraNode.setScale(initialZoom)
        
        positionProgressBar()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 2
        view.addGestureRecognizer(panGesture)
    }

    
    func positionProgressBar() {
        guard let scene = scene else { return }
        let offsetY: CGFloat = 50
        
        progressBar.position = CGPoint(
            x: 0,
            y: -scene.size.height / 2 + offsetY
        )
    }
    
    func updateCameraZoom() {
        let paintedCount = hexagonsBackground.paintedHexagonsCount()
        let zoomDecreaseFactor: CGFloat = 0.005
        
        var newScale = initialZoom + (CGFloat(paintedCount) * zoomDecreaseFactor)
        
        newScale = max(minZoom, min(newScale, maxZoom))
        
        let zoomAction = SKAction.scale(to: newScale, duration: 0.3)
        
        cameraNode.run(zoomAction)
        
        hexagonsBackground.updateTrailWidth(forZoom: newScale)
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
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        hexagonsBackground.drawTrail(at: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hexagonsBackground.finalizeDrawing()
        hexagonsBackground.removeTrail()

        let paintedCount = hexagonsBackground.paintedHexagons
        let totalHexagons = hexagonsBackground.totalHexagons
        let filledPercentage = CGFloat(paintedCount) / CGFloat(totalHexagons)

//        botController.createBot(hexGrid: hexagonsBackground)

        progressBar.updateProgressBar(filledPercentage: filledPercentage)
        
        
//        print("Painted: \(paintedCount), Total: \(totalHexagons), Percentage: \(filledPercentage)")
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

    func notifyTouchesEnded() {
        touchesEnded(Set<UITouch>(), with: nil)
    }
}
