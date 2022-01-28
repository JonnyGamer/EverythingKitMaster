//
//  GameScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit
import GameplayKit

enum MusicList: String, MusicType {
    case theIndustry = "The Industry"//Music.o.playMusic("The Industry")
}

class GameScene: Scene, SpeakerScene {
    
    var backgroundMusic: MusicType = MusicList.theIndustry
    var peopleToSpeakWith: [SuperCharacters : Communication] = [
        .base(.basketShop, 250, 250) : .message(["Foo Bar!"])
    ]
    
    override func touchBegan() {
        
        if chatBox == nil {
        
            let woah = DispatchQueue.init(label: "")
            woah.async { [self] in
                message(.long([
                    .message(["Hi there"]),
                    .message(["This is something else"]),
                    .multipleChoice(["Choose One"], [
                        (["Pick me!"], .message(["You're trash."])),
                        (["Pick me!"], .message(["You're trash."])),
                        (["No...","Pick me!"], .message(["You're actually trash!"])),
                        (["Switch Scene!"], .present(GameScene.self, incomingFrom: .left)),
                    ]),
                    .playMusic(MusicList.theIndustry),
                    .run {
                        return .random() ? .message(["1"]) : .message(["0"])
                    }
                ]))
            }
            
        }
        
    }
    
    override func movedToView() {
    
    }
    
    override func began() {
        background.color = .white
        
        setupScene(self)
        
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
