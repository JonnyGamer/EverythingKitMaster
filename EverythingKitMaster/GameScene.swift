//
//  GameScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit
import GameplayKit



class GameScene: Scene {
    
    override func touchBegan() {
        //present(ShuttleRoom1.self)
    }
    
    override func movedToView() {
    
    }
    
    override func began() {
        background.color = .white 
        
        SpriteButton.init(size: .hundred, fillColor: (0.53, 0.2, 1.0), rgb: false).then {
            $0.button.addChild(SKLabelNode(text: "foo").then({ text in
                text.basicText(keepInside: .hundred.times(0.9))
            }))
            connectButton($0)
            $0.touchEndedOn = { _ in
                self.present(GameScene.self, incomingFrom: .left)
            }
            addChild($0)
            $0.place(.right, on: .screen, .right)
            $0.place(.top, on: .screen, .top)
        }
        
        
        SpriteButton.init(size: .init(width: 400, height: 200), fillColor: (0.53, 0.2, 1.0), rgb: false).then {
            $0.button.addChild(SKLabelNode(text: "Antilone").then({ text in
                text.basicText(keepInside: .init(width: 400, height: 200).times(0.9))
            }))
            connectButton($0)
            $0.touchEndedOn = { _ in
                self.present(ShuttleRoom1.self)
            }
            addChild($0)
            $0.centerAt(point: .midScreen)
        }
        
        /*
        let stack = HStack([
            
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            Toggle.init(default: false, height: 100, color: .green),
            
            Toggle.init(default: false, height: 400, color: .blue).then { i in
                SKLabelNode.init(text: "tap me").then { j in
                    j.basicText(keepInside: i.calculateAccumulatedFrame().size.times(0.5))
                    j.fontColor = .init(white: 0.9, alpha: 1.0)
                    j.place(.top, on: i, .bottom)
                    i.addChild(j)
                }
            },
            
        ])
        stack.addPadding()
        
        addChild(stack)
        stack.keepInside(.screenSize.times(0.9))
        stack.centerAt(point: .midScreen)
        */
        
    }
    
}
