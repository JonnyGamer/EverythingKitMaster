//
//  ViewController.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            build(view, GameScene())
            view.showsNodeCount = true
        }
    }
}

