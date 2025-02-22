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
    var lastCameraPosition: CGPoint?
    var panJustHappened = false
    var didPanCamera = false
    
    var initialZoom: CGFloat = 0.4
    var minZoom: CGFloat = 0.4
    var maxZoom: CGFloat = 1.2
    var hexagonSize: CGFloat = 20.0
    
    override func didMove(to view: SKView) {
        addChild(hexagonsBackground)
        
        addChild(cameraNode)
        camera = cameraNode
        
        hexagonsBackground.createHexagons(radius: 50, size: hexagonSize)
        
        cameraNode.setScale(initialZoom)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 2
        view.addGestureRecognizer(panGesture)
    }
    
    func updateCameraZoom() {
        let paintedCount = hexagonsBackground.paintedHexagonsCount()
        let zoomDecreaseFactor: CGFloat = 0.007
        
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
            cameraNode.position = newPosition
        }
        
        if recognizer.state == .ended || recognizer.state == .cancelled {
            DispatchQueue.main.async {
                self.didPanCamera = false
                self.notifyTouchesEnded()
            }
        }
    }

    func notifyTouchesEnded() {
        touchesEnded(Set<UITouch>(), with: nil)
    }

    
}
