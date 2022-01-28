//
//  ChatBox.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

class SelectionBox: SKShapeNode, SuperTouchable {
    
    func _touchBegan() {
        superChatBox.selected(id)
    }
    func _touchReleased() {}
    func _touchEndedOn() {}
    var touchBegan: (SelectionBox) -> () = {_ in}
    var touchReleased: (SelectionBox) -> () = {_ in}
    var touchEndedOn: (SelectionBox) -> () = {_ in}
    
    var id: Int = 0
    var superChatBox: ChatBox!
    
    static func Make(id: Int, words: [String], width: CGFloat, corner: CGFloat) -> SelectionBox {
        let scale: CGFloat = 0.5
        let height: CGFloat = (40 * CGFloat(words.count) * scale) + (60 * scale)
        let foo = SelectionBox.init(rectOf: .init(width: width, height: height), cornerRadius: 40 * scale).then {
            $0.fillColor = .white
            $0.strokeColor = .black
            $0.lineWidth = 10 * scale
            $0.id = id
        }
        
        var woah: [SKNode] = []
        for i in 1...words.count {
            let wow = SKLabelNode.init(text: words[i-1])
            wow.setScale(scale)
            print(wow.fontSize)
            wow.basicText(keepInside: .init(width: foo.frame.width * 0.9, height: 35 * scale))
            if wow.fontSize > 32 * scale {
                wow.fontSize = 32 * scale
            }
            print(wow.fontSize)
            woah.append(wow)
        }
        let paragraph = VStack(woah)
        paragraph.addPadding()
        paragraph.leftAlign()
        paragraph.centerAt(point: .zero)
        foo.addChild(paragraph)
        return foo
    }
}


class ChatBox: SKShapeNode {
    
    var _next = false
    var _result: Communication?
    func next() {
        if !options.isEmpty {
            _result = options[selected].1
        }
        _next = true
    }
    
    // Multiple Choice Options
    var options: [(SelectionBox, Communication)] = []
    
    var selected = -1
    func selected(_ thisId: Int) {
        if options.isEmpty { return }
        
        let thisId = thisId % options.count
        
        if selected == thisId { return }
        
        if selected >= 0 {
            let this = options[selected].0
            this.run(.scale(by: 1/1.1, duration: 0.1).easeInEaseOut())
            this.run(.fillColor(from: (1,0.5,0.5), to: (1,1,1), rgb: true, duration: 0.1))
        }

        selected = thisId
        let this = options[selected].0
        this.run(.scale(by: 1.1, duration: 0.1).easeInEaseOut())
        this.run(.fillColor(from: (1,1,1), to: (1,0.5,0.5), rgb: true, duration: 0.1))
    }
    func moveSelection(_ d: Int) {
        selected(selected + options.count - d)
    }
    
    func addSelection(words: [String], result: Communication) {
        let subBox = SelectionBox.Make(id: options.count, words: words, width: 200, corner: 20)
        subBox.place(.top, on: self, .bottom)
        subBox.place(.right, on: self, .right)
        subBox.superChatBox = self
        self.addChild(subBox)
        options.append((subBox, result))
    }
    
    
    static func Make(words: [String], width: CGFloat, corner: CGFloat) -> ChatBox {
        let scale: CGFloat = 1
        let foo = ChatBox.init(rectOf: .init(width: width, height: (40 * CGFloat(words.count) * scale) + (60 * scale)), cornerRadius: 40 * scale).then {
            $0.fillColor = .white
            $0.strokeColor = .black
            $0.lineWidth = 10 * scale
            
            var woah: [SKNode] = []
            for i in 1...words.count {
                let wow = SKLabelNode.init(text: words[i-1])
                wow.setScale(scale)
                print(wow.fontSize)
                wow.basicText(keepInside: .init(width: $0.frame.width * 0.9, height: 35 * scale))
                if wow.fontSize > 32 * scale {
                    wow.fontSize = 32 * scale
                }
                print(wow.fontSize)
                woah.append(wow)
            }
            let paragraph = VStack(woah)
            paragraph.addPadding()
            paragraph.leftAlign()
            paragraph.centerAt(point: .zero)
            $0.addChild(paragraph)
        }
        
        return foo
    }
    
}

extension Scene {
    
    func removeOldChatBox() {
        if let c = chatBox {
            c.run(.scale(by: 0.5, duration: 0.2).easeInOut())
            c.fadeOutGoodBye()
        }
        chatBox = nil
    }
    
    func addChatBox(words: [String], options: [([String], Communication)]) {
        removeOldChatBox()
        
        func dropDown(_ box: ChatBox) {
            box.centerAt(point: .midScreen)
            box.place(.top, on: .screen, .top)
            box.position.y -= 20
            let saveY = box.position.y
            box.place(.bottom, on: .screen, .top)
            box.run(.moveTo(y: saveY, duration: 0.2).easeOut())
        }
        
        let foo = ChatBox.Make(words: words, width: min(w*0.8, 700), corner: 50)
        
        for (words, result) in options {
            foo.addSelection(words: words, result: result)
        }
        if !options.isEmpty {
            foo.selected(0)
        }
        
        dropDown(foo)
        
        addChild(foo)
        chatBox = foo
    }
    
}
