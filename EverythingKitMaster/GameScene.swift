//
//  GameScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit
import GameplayKit

class GameScene: Scene, SpeakerScene {
    var peopleToSpeakWith: [SuperCharacters : SpeakerEnum] = [
        .base(.basketShop) : .message(["Foo Bar!"])
    ]
    
    override func touchBegan() {
        
        addChatBox(words: [
            "1, 2, 3, testing a very very long long string ;)",
            "woah...",
            "knewfjkndwnkjwenjdnwkejknkjnfjknfewnkjew",
            "knewfjkndwnkjwenjdnwkejknkjnfjknfewnkjew",
            "knewfjkndwnkjwenjdnwkejknkjnfjknfewnkjew",
            "knewfjkndwnkjwenjdnwkejknkjnfjknfewnkjew",
            "knewfjkndwnkjwenjdnwkejknkjnfjknfewnkjew",
        ])
        
//        canSpeakWith = Speak(color: .red, size: .hundred).then {
//            $0.speech = .longMessage([
//                .message(["wo"]),
//                .message(["bar"]),
//                .message(["done."]),
//            ])
//            $0.personSpeaking = $0
//        }
//        
//        pressedA()
        
        //self.run(.moveBy(x: 100, y: 0, duration: 1.0).easeInEaseOut())
    }
    
    override func movedToView() {
//        self.bringUpKeyboard(instant: false, .complete) {
//            print("Keyboard")
//        }
    }
    
    override func began() {
        background.color = .white
        
        SpriteButton.init(size: .hundred, fillColor: (0.53, 0.2, 1.0), rgb: false).then {
            $0.button.addChild(SKLabelNode(text: "foo").then({ text in
                text.basicText(keepInside: .hundred.times(0.9))
            }))
            connectButton($0)
            $0.touchEndedOn = { _ in
                self.present(GameScene(.screenSize), incomingFrom: .left)
            }
            addChild($0)
            $0.place(.right, on: .screen, .right)
            $0.place(.top, on: .screen, .top)
        }
        
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
        
    }
    
}
