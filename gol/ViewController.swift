//
//  ViewController.swift
//  gol
//
//  Created by Gadi Lifshitz on 14/04/2020.
//  Copyright © 2020 Gadi Lifshitz. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit
import AppKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                 scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

