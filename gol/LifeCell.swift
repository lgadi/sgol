//
//  LifeCell.swift
//  gol
//
//  Created by Gadi Lifshitz on 15/04/2020.
//  Copyright © 2020 Gadi Lifshitz. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class LifeCell : Equatable {
    let x : Int
    let y : Int
    let scene: SKScene
    var alive: Bool
    var oldRect: SKShapeNode?
    init(x: Int, y: Int, scene: SKScene, alive: Bool) {
        self.x = x
        self.y = y
        self.scene = scene
        self.alive = alive
        self.oldRect = nil
    }
    
    func draw() {
        if oldRect != nil {
            oldRect!.removeFromParent()
        }
        let rect = SKShapeNode.init(rect: CGRect(
            origin: CGPoint(x: self.x*10, y: self.y*10),
               size: CGSize(width: 10, height: 10)))
        rect.fillColor = alive ? SKColor.white:SKColor.black
        rect.run(SKAction.fadeIn(withDuration: 0))
        self.oldRect = rect
        scene.addChild(rect)
    }
    public static func ==(lhs: LifeCell, rhs: LifeCell) -> Bool {
        lhs.alive == rhs.alive
    }
}
