//
//  GameScene.swift
//  gol
//
//  Created by Gadi Lifshitz on 14/04/2020.
//  Copyright © 2020 Gadi Lifshitz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GameStateProtocol {
    
    func stateChange(active: Bool) {
        startButton?.setText(text: active ? "Stop":"Start")
    }
    
    
    var timer: Timer = Timer()
    
    var startButton: Button?
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
        self.startButton = Button(scene:self, origin: CGPoint(x: 10, y: 10), size: CGSize(width: 100, height:50), text: "Start")
        startButton?.draw()
        board = Board(scene: self)
        board!.addStateChangeListener(listener: self)
        board!.sceneDidLoad();
    }
    
    func updateRegion(x: Int, y: Int) {
        board?.drawAll()
    }
    
    func toggleTimer() {
        if timer.isValid {
            timer.invalidate()
            stateChange(active: false)
        
        }
        else {
            stateChange(active: true)
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: board!.drawBoard)
            timer.fire()

            
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        //todo create text view in a normal place and edit stuff...
       // let txt = NSTextField(frame: NSRect(x:10,y:10,width:100,height:50))
        //view.addSubview(txt)
        
        let widthField = TextField(frame: NSRect(x: 100,y: 10, width: 100,height: 20))
        let heightField = TextField(frame: NSRect(x: 220,y: 10, width: 100,height: 20))
//        let handler : TextFieldListener = {
//            class MyHandler : TextFieldListener {
//                func textFieldChanged(newValue: String) {
//                    print("handler new value is \(newValue)")
//                }
//            }
//            return MyHandler()
//        }()
        
        class BaseHandler : TextFieldListener {
            func textFieldChanged(newValue: String) {
                print("should never be called")
            }
            
            let game:GameScene
            init(game:GameScene) {
                self.game = game
            }
        }
        widthField.addTextChangedListener(listener:
        {
            class MyHandler : BaseHandler {
                override func textFieldChanged(newValue: String) {
                    let height = Int(newValue)
                    game.board!.setWidth(height ?? game.board!.getWidth())
                }
            }
            return MyHandler(game:self)
        }())
        
        heightField.addTextChangedListener(listener:
        {
            class MyHandler : BaseHandler {
                override func textFieldChanged(newValue: String) {
                    let height = Int(newValue)
                    game.board!.setHeight(height ?? game.board!.getHeight())
                }
            }
            return MyHandler(game:self)
        }())
        view.addSubview(widthField)
        view.addSubview(heightField)
        toggleTimer()
    }
    
    override func willMove(from view: SKView) {
    }
    
    override func willChangeValue(forKey key: String) {
    }
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
       print("did change size")
    }
    
    override func mouseDown(with event: NSEvent) {
        
        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        let convertedPoint =  scene?.convertPoint(fromView: CGPoint(x:x,y:y))
        for  listener in mouseClickListeners {
            let rect = listener.getRect()
            if rect.contains(convertedPoint!) {
                listener.mouseClicked()
                draggedCells.insert(rect)
            }
        }
    }
    
    var draggedCells = Set<CGRect>()
    override func mouseDragged(with event: NSEvent) {
        print("mouse dragged")
        
        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        let convertedPoint =  scene?.convertPoint(fromView: CGPoint(x:x,y:y))
        for  listener in mouseClickListeners {
            let rect = listener.getRect()
            if !draggedCells.contains(rect) {
                if rect.contains(convertedPoint!) {
                    listener.mouseClicked()
                    draggedCells.insert(rect)
                }
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        print("mouseUp")
        draggedCells.removeAll()
    }
    
    override func keyDown(with event: NSEvent) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension CGRect: Hashable {
    static func == (lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.origin == rhs.origin && lhs.size == rhs.size
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin.x)
        hasher.combine(origin.y)
        hasher.combine(size.width)
        hasher.combine(size.height)
    }
}
