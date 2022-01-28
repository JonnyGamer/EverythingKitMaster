//
//  ChatBox.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

class ChatBox: SKShapeNode {
    
}

extension Scene {
    
    func addChatBox(words: [String]) {
        if let c = chatBox {
            //c.run(.moveBy(x: 0, y: -200, duration: 0.2).easeInOut())
            c.run(.scale(by: 0.5, duration: 0.2).easeInOut())
            c.fadeOutGoodBye()
        }
        
        let foo = ChatBox.init(rectOf: .init(width: min(w*0.9, 700), height: CGFloat(40 * words.count) + 60), cornerRadius: 50).then {
            $0.fillColor = .white
            $0.strokeColor = .black
            $0.lineWidth = 10
            
            $0.centerAt(point: .midScreen)
            $0.place(.top, on: .screen, .top)
            $0.position.y -= 20
            let saveY = $0.position.y
            $0.place(.bottom, on: .screen, .top)
            $0.run(.moveTo(y: saveY, duration: 0.2).easeOut())
            
            var woah: [SKNode] = []
            for i in 1...words.count {
                let wow = SKLabelNode.init(text: words[i-1])
                wow.basicText(keepInside: .init(width: $0.frame.width * 0.9, height: 35))
                woah.append(wow)
            }
            let paragraph = VStack(woah)
            paragraph.addPadding()
            paragraph.leftAlign()
            paragraph.centerAt(point: .zero)
            $0.addChild(paragraph)
            
        }
        addChild(foo)
        chatBox = foo
        
    }
    
}
