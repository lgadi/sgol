//
//  GameScene.swift
//  gol
//
//  Created by Gadi Lifshitz on 14/04/2020.
//  Copyright © 2020 Gadi Lifshitz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let MAX_X:Int = 10
    let MAX_Y:Int = 10
    
    class LifeCell {
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
        
    }
        
    
    var cells = [LifeCell]()
    
    func getNeighborsCount(cell: LifeCell) -> Int {
        let x:Int = cell.x
        let y:Int = cell.y
        let fromx:Int = x == 0 ? x : x - 1
        let fromy:Int = y == 0 ? y : y - 1
        let tox:Int = (x == MAX_X - 1) ? x + 1 : x + 2
        let toy:Int = (y == MAX_Y - 1) ? y + 1 : y + 2
        var count = 0
        for i in fromx ..< tox {
            for j in fromy ..< toy {
                if cells[j*10+i].alive {
                   count += 1
                }
            }
        }
        if cells[y*10+x].alive { count = count - 1 }
        return count
    }
    
    func cloneCells() -> [LifeCell] {
        var newCells = [LifeCell]()
        for cell in cells {
            newCells.append(LifeCell(x:cell.x, y: cell.y, scene:cell.scene, alive:cell.alive))
        }
        return newCells
    }
    
    func calculateScreen() {
        let newCells = cloneCells()
        for x in 0..<MAX_X {
            for y in 0..<MAX_Y {
                let cellLocation = y*10+x
                let neighborsCount = getNeighborsCount(cell:cells[cellLocation])
                if neighborsCount < 2 || neighborsCount > 3{
                    newCells[cellLocation].alive = false
                }
                if neighborsCount == 3 {
                    newCells[cellLocation].alive = true
                }
            }
        }
        cells = newCells
    }
    
    override func sceneDidLoad() {
        
        let rect = SKShapeNode.init(rect: CGRect(
            origin: CGPoint(x:300, y: 300),
               size: CGSize(width: 100, height: 100)))
        
        rect.run(SKAction.fadeIn(withDuration: 0))
        self.addChild(rect)
        
        for x in 0..<10 {
            for y in 0..<10 {
                cells.append(LifeCell(x:x, y:y, scene: self, alive: false))
            }
        }
        
        cells[0*10+0].alive = true
        cells[5*10+5].alive = true
        cells[6*10+5].alive = true
        cells[9*10+9].alive = true
        cells[5*10+7].alive = true
        cells[5*10+8].alive = true

    }
    
    @objc func drawBoard(timer: Timer)  {
        for cell in cells {
            cell.draw()
        }
        calculateScreen()
        
    }
    
    override func didMove(to view: SKView) {
        print("didMove start")
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: drawBoard)
        timer.fire()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        print(scene?.size ?? 0)
        print(oldSize)
    }
    
    override func mouseDown(with event: NSEvent) {
        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        print("converted point: \(String(describing: scene?.convertPoint(fromView: CGPoint(x:x,y:y))))")
        print("x:\(x), y:\(y)")
    }
    
    override func mouseDragged(with event: NSEvent) {
    }
    
    override func mouseUp(with event: NSEvent) {
    }
    
    override func keyDown(with event: NSEvent) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
