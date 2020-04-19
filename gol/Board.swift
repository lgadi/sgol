//
//  Board.swift
//  gol
//
//  Created by Gadi Lifshitz on 16/04/2020.
//  Copyright © 2020 Gadi Lifshitz. All rights reserved.
//

import Foundation
import SpriteKit


class Board {
    var cells: [LifeCell]
    let scene: GameScene
    var MAX_X:Int = 30
    var MAX_Y:Int = 30
    var changedCells: [LifeCell]
    var gameStateListeners: [GameStateProtocol]
    
    init(scene: GameScene) {
        self.scene = scene
        self.cells = [LifeCell]()
        self.changedCells = [LifeCell]()
        self.gameStateListeners = [GameStateProtocol]()
    }
    
    func getNeighborsCount(cell: LifeCell) -> Int {
        var count = 0
        for y in cell.y-1 ..< cell.y+2 {
            if y<0 || y>=MAX_Y { continue }
            for x in cell.x-1 ..< cell.x+2 {
                if x<0 || x>=MAX_X { continue }
                if x == cell.x && y == cell.y { continue }
                if cells[y*MAX_X+x].alive  {
                    count += 1
                }
            }
        }
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
        for y in 0..<MAX_Y {
            for x in 0..<MAX_X {
                let cellLocation = y*MAX_X+x
                let cell = cells[cellLocation]
                let neighborsCount = getNeighborsCount(cell:cell)
                newStatus[cellLocation] = cell.alive
                cell.setLabel(text: String(neighborsCount))
                if neighborsCount < 2 || neighborsCount > 3 {
                    newStatus[cellLocation] = false
                }
                if neighborsCount == 3 {
                    newStatus[cellLocation] = true
                }
                if newStatus[cellLocation] != cell.alive {
                    changedCells.append(cell)
                }
            }
        }
        
        let shouldStopGame = shouldStop(cells:cells, statuses: newStatus)
        for i in 0..<cells.count {
            cells[i].alive = newStatus[i]
        }
        
        return shouldStopGame
    }
    
    
    fileprivate func createAllCells() {
        for y in 0..<MAX_Y {
            for x in 0..<MAX_X {
                cells.append(LifeCell(x:x, y:y, scene: self.scene, alive: false))
            }
        }
    }
    
    func sceneDidLoad() {
        print("board initializing")
        createAllCells()
    }
    func getWidth() -> Int {
        return MAX_X
    }
    
    func getHeight() -> Int {
        return MAX_Y
    }
    
    func setHeight(_ height:Int) {
        self.MAX_Y = height
        boardChanged()
    }
    
    func boardChanged() {
        clearAll()
        createAllCells()
        drawAll()
    }
    
    func setWidth(_ width:Int) {
        print("width set to:\(width)")
        self.MAX_X = width
        boardChanged()
    }
    func clearAll() {
        for cell in cells {
            cell.removeFromParent()
        }
        cells.removeAll()
    }
    func drawAll() {
        var updated = 0
        for cell in cells {
            let count = String(getNeighborsCount(cell: cell))
            if cell.cellLabel.text != count {
                cell.setLabel(text: count)
                updated += 1
            }
        }
        for cell in changedCells {
            cell.draw()
            updated += 1
        }
        changedCells.removeAll()
        print("updated \(updated) cells overall")
    }
    
    func addStateChangeListener(listener: GameStateProtocol) {
        gameStateListeners.append(listener)
    }
    
    @objc func drawBoard(timer: Timer)  {
        drawAll()
        if calculateScreen() {
            timer.invalidate()
            for listenere in gameStateListeners {
                listenere.stateChange(active: false)
            }
          //  button?.setText(text: "Start")
        }
    }
}
