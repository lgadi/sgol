//
//  TextField.swift
//  gol
//
//  Created by Gadi Lifshitz on 16/04/2020.
//  Copyright © 2020 Gadi Lifshitz. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TextField : NSTextField {
    
    var listeners = [TextFieldListener]()
    
    override func textDidChange(_ notification: Notification) {
    }
    override func textDidEndEditing(_ notification: Notification) {
        for listener in listeners {
            listener.textFieldChanged(newValue: self.stringValue)
        }
    }
    func addTextChangedListener(listener: TextFieldListener) {
        listeners.append(listener)
    }
}

protocol TextFieldListener {
    func textFieldChanged(newValue: String)
}
