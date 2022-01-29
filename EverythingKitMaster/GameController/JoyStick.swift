//
//  JoyStick.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/28/22.
//

import SpriteKit

extension RootScene {
    func joyStick() {
        do {
            let foo = SKSpriteNode.init(imageNamed: "JoyPad")
            foo.keepInside(.hundred.times(2))
            addChild(foo)
            foo.centerAt(point: .zero)
            foo.position.x += foo.size.width
            foo.position.y += foo.size.height
//            foo.place(.right, on: self, .right)
//            foo.place(.bottom, on: self, .bottom)
            foo.fadeIn()
            foo.zPosition = 10000
            supperRadius = foo.size.width/2
            theJoyPad = foo
        }
        do {
            let foo = SKSpriteNode.init(imageNamed: "JoyStick")
            foo.keepInside(.hundred)
            foo.centerAt(point: theJoyPad.position)
            //foo.setScale(min(frame.height/12,frame.width/12) / foo.frame.width)
            addChild(foo)
            //foo.position.x -= (self.size.width) * (1/3)
            //foo.position.y -= (self.size.height) * (1/3)
            foo.fadeIn()
            foo.zPosition = 10001
            theJoyStick = foo
            joyPosition = foo.position
        }
    }
}
