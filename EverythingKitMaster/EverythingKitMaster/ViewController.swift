//
//  ViewController.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import Cocoa
import SpriteKit
import GameplayKit
import GameController

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            build(view, GameScene())
            view.showsNodeCount = true
            setupGameController()
        }
    }
    
    // MARK: - Game controller Values -
    var gamePadCurrent: GCController?
    var gamePadLeft: GCControllerDirectionPad?
    var gamePadRight: GCControllerDirectionPad?
    var dPad: GCControllerDirectionPad?
    var rightThumbStickX: GCControllerAxisInput?
    var rightThumbStickY: GCControllerAxisInput?
    var rightThumbStickButton: GCControllerButtonInput?
    var leftThumbStickX: GCControllerAxisInput?
    var leftThumbStickY: GCControllerAxisInput?
    var leftThumbStickButton: GCControllerButtonInput?
    
    var delta: CGPoint = CGPoint.zero
    var keyboard: GCKeyboard? = nil
    
}

