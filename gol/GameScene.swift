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
    
    var timer: Timer = Timer()
    var cells = [LifeCell]()
    var button: Button?
    var mouseClickListeners = [MouseClickProtocol]()

    func addMouseClickListener(listener:MouseClickProtocol) {
        mouseClickListeners.append(listener)
    }
    
    func removeMouseListener(listener:MouseClickProtocol) {
        mouseClickListeners.removeAll{$0.getRect() == listener.getRect()}
    }
    
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
                if cells[i*10+j].alive {
                    count += 1
                }
            }
        }
        if cells[y*10+x].alive { count = count - 1 }
        return count
    }
    
    func shouldStop(cells:[LifeCell], statuses:[Bool]) -> Bool {
        for i in 0..<cells.count {
            if cells[i].alive != statuses[i] {return false}
        }
        return true
    }
    
    func calculateScreen() -> Bool {
        
        var newStatus = [Bool](repeating: false, count:MAX_X*MAX_Y)
        for x in 0..<MAX_X {
            for y in 0..<MAX_Y {
                newStatus.append(false)
                let cellLocation = y*MAX_Y+x
                let cell = cells[cellLocation]
                let neighborsCount = getNeighborsCount(cell:cell)
                cell.setLabel(text: String(neighborsCount))
                if neighborsCount < 2 || neighborsCount > 3 {
                    newStatus[cellLocation] = false
                }
                if neighborsCount == 3 {
                    newStatus[cellLocation] = true
                }
            }
        }
        
        let shouldStopGame = shouldStop(cells:cells, statuses: newStatus)
        for i in 0..<cells.count {
            cells[i].alive = newStatus[i]
        }
        
        return shouldStopGame
    }
    
    override func sceneDidLoad() {
        
        self.button = Button(scene:self, origin: CGPoint(x: 300, y: 300), size: CGSize(width: 200, height:100), text: "Start")
        button?.draw()
        
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
        if calculateScreen() {
            timer.invalidate()
        }
    }
    
    func toggleTimer() {
        if timer.isValid {
            timer.invalidate()
            print("to Start")
            button?.setText(text: "Start")
        
        }
        else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: drawBoard)
            timer.fire()
            print("to Stop")

            button?.setText(text: "Stop")
        }
    }
    
    override func didMove(to view: SKView) {
        print("didMove start")
        toggleTimer()
        
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
        let convertedPoint =  scene?.convertPoint(fromView: CGPoint(x:x,y:y))
        let cx = convertedPoint?.x
        let cy = convertedPoint?.y
        print("converted point: \(String(describing: cx)),\(String(describing: cy))")
        print("x:\(x), y:\(y)")
        for  listener in mouseClickListeners {
            let rect = listener.getRect()
            if rect.contains(convertedPoint!) {
                listener.mouseClicked()
            }
        }
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
