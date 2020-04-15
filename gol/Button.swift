//
//  Button.swift
//  gol
//
//  Created by Gadi Lifshitz on 15/04/2020.
//  Copyright © 2020 Gadi Lifshitz. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Button : MouseClickProtocol {
    
    func mouseClicked() {
        print("Mouse Clicked on button")
        scene.toggleTimer()
    }
    
    func getRect() -> CGRect {
        CGRect(origin: origin, size: size)
    }
    
    let scene: GameScene
    let origin: CGPoint
    let size: CGSize
    var text: String
    let cellLabel: SKLabelNode
    
    
    init(scene: GameScene, origin: CGPoint, size: CGSize, text: String) {
        self.scene = scene
        self.origin = origin
        self.size = size
        self.text = text
        self.cellLabel = SKLabelNode()
        scene.addMouseClickListener(listener: self)
    }
    
    func setText(text: String) {
        self.text = text
        cellLabel.text = self.text
    }
    
    func draw() {
       let rect = SKShapeNode.init(rect: CGRect(
        origin: self.origin,
        size: self.size))
        
        rect.run(SKAction.fadeIn(withDuration: 0))
        scene.addChild(rect)
        cellLabel.fontSize = 12
        let x:Int = Int(origin.x)+Int(size.width/2)
        let y:Int = Int(origin.y)+Int(size.height/2)-5
        cellLabel.position = CGPoint(x:x,y: y)
        cellLabel.text = text
        scene.addChild(cellLabel)
    }
}
