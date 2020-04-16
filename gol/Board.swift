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
    let MAX_X:Int = 10
    let MAX_Y:Int = 20
    
    init(scene: GameScene) {
        self.scene = scene
        self.cells = [LifeCell]()
    }
    
    func getNeighborsCount(cell: LifeCell) -> Int {
           let x:Int = cell.x
           let y:Int = cell.y
           let fromx:Int = x == 0 ? x : x - 1
           let fromy:Int = y == 0 ? y : y - 1
           let tox:Int = (x == MAX_X - 1) ? x + 1 : x + 2
           let toy:Int = (y == MAX_Y - 1) ? y + 1 : y + 2
           var count = 0
           for i in fromy ..< toy {
               for j in fromx ..< tox {
                   if cells[i*MAX_X+j].alive {
                       count += 1
                   }
               }
           }
           if cell.alive { count = count - 1 }
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
                newStatus.append(false)
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
            }
        }
        
        let shouldStopGame = shouldStop(cells:cells, statuses: newStatus)
        for i in 0..<cells.count {
            cells[i].alive = newStatus[i]
        }
        
        return shouldStopGame
    }
    
    func sceneDidLoad() {
        print("board initializing")
        for y in 0..<MAX_Y {
            for x in 0..<MAX_X {
                cells.append(LifeCell(x:x, y:y, scene: self.scene, alive: false))
            }
        }
    }
    
    func drawAll() {
        for cell in cells {
            cell.setLabel(text: String(getNeighborsCount(cell: cell)))
            cell.draw()
        }
    }
    
    @objc func drawBoard(timer: Timer)  {
        drawAll()
        if calculateScreen() {
            timer.invalidate()
          //  button?.setText(text: "Start")
        }
    }
}