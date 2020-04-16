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
    
    var timer: Timer = Timer()
    
    var button: Button?
    var mouseClickListeners = [MouseClickProtocol]()
    var board: Board?

    required init?(coder aDecoder: NSCoder) {
        self.board = nil
        super.init(coder: aDecoder)
    }
    
    func addMouseClickListener(listener:MouseClickProtocol) {
        mouseClickListeners.append(listener)
    }
    
    func removeMouseListener(listener:MouseClickProtocol) {
        mouseClickListeners.removeAll{$0.getRect() == listener.getRect()}
    }
    
    override func sceneDidLoad() {
        self.button = Button(scene:self, origin: CGPoint(x: 300, y: 300), size: CGSize(width: 200, height:100), text: "Start")
        button?.draw()
        board = Board(scene: self)
        board!.sceneDidLoad();
    }
    
    func updateRegion(x: Int, y: Int) {
        board?.drawAll()
    }
    
    func toggleTimer() {
        if timer.isValid {
            timer.invalidate()
            button?.setText(text: "Start")
        
        }
        else {
            button?.setText(text: "Stop")
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: board!.drawBoard)
            timer.fire()

            
        }
    }
    
    override func didMove(to view: SKView) {
        toggleTimer()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
       
    }
    
    override func mouseDown(with event: NSEvent) {
        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        let convertedPoint =  scene?.convertPoint(fromView: CGPoint(x:x,y:y))
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
