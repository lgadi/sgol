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

class LifeCell : Equatable, MouseClickProtocol, Hashable {
    
    let BASEX = 100
    let BASEY = 100
    let WIDTH = 20
    let HEIGHT = 20
    let x : Int
    let y : Int
    let origin: CGPoint
    let size: CGSize
    let scene: GameScene
    var alive: Bool
    var oldRect: SKShapeNode?
    var cellLabel: SKLabelNode
    var rect: SKShapeNode
    init(x: Int, y: Int, scene: GameScene, alive: Bool) {
        self.x = x
        self.y = y
        self.scene = scene
        self.alive = alive
        self.oldRect = nil
        self.origin = CGPoint(x: self.x*WIDTH+BASEX, y: self.y*HEIGHT+BASEY)
        self.size = CGSize(width: WIDTH, height: HEIGHT)
        self.cellLabel = SKLabelNode()
        cellLabel.fontSize = 12
        cellLabel.fontColor = SKColor.blue
        cellLabel.position = CGPoint(x:Int(origin.x)+WIDTH/2,y: Int(origin.y)+HEIGHT/2-5)
        scene.addChild(cellLabel)
        rect = SKShapeNode.init(rect: CGRect(
            origin: origin,
            size: size))
        scene.addChild(rect)
        scene.addMouseClickListener(listener: self)
    }
    
    func getRect() -> CGRect {
        return CGRect(origin:origin, size:size)
    }
    
    func draw() {
        rect.fillColor = alive ? SKColor.white:SKColor.black
        rect.run(SKAction.fadeIn(withDuration: 0))
    }
    
    func removeFromParent() {
        cellLabel.removeFromParent()
        rect.removeFromParent()
        scene.removeMouseListener(listener: self)
    }
    
    func setLabel(text: String) {
        cellLabel.fontColor = self.alive ? SKColor.blue:SKColor.white
        cellLabel.text = text
    }
    
    public static func ==(lhs: LifeCell, rhs: LifeCell) -> Bool {
        lhs.x == rhs.x &&
            lhs.y == rhs.y &&
            lhs.alive == rhs.alive
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    func mouseClicked() {
        print("mouse clicked on LifeCell(\(x),\(y))")
        scene.cellStateChanged(cell: self)
        self.alive = !self.alive
        self.setLabel(text: "*")
        self.draw()
        scene.updateRegion(x: self.x, y: self.y)
    }
    
}
