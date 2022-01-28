//
//  StackKit.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

open class HStack: SKNode {
    var items = 0
    
    public init(_ nodes: [SKNode]) {
        super.init()
        var previousNode: SKNode!
        for i in nodes {
            items += 1
            addChild(i)
            i.position = .zero
            if previousNode != nil {
                i.centerAt(y: previousNode.calculateAccumulatedFrame().midY)
                i.place(.left, on: previousNode, .right)
            }
            previousNode = i
        }
    }
    public override init() {
        super.init()
    }
    
    func addPadding() {
        let wow = calculateAccumulatedFrame().size.width * 0.1 * (1/CGFloat(items))
        for i in 0..<children.count {
            children[i].position.x += wow * CGFloat(i)
        }
    }
    
    open override func copy() -> Any {
        return HStack.init(children.map { $0.copied })
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class Paragraph: VStack {
    
    public init(_ nodes: [String], _ then: (SKLabelNode) -> ()) {
        let newNodes: [SKLabelNode] = nodes.map {
            let text = SKLabelNode.init(text: $0)
            then(text)
            return text
        }
        super.init(newNodes)
    }
    
    public override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class VStack: SKNode {
    var items = 0
    
    public init(_ nodes: [SKNode]) {
        super.init()
        var previousNode: SKNode!
        for i in nodes {
            items += 1
            addChild(i)
            i.position = .zero
            if previousNode != nil {
                i.centerAt(x: previousNode.calculateAccumulatedFrame().midX)
                i.place(.top, on: previousNode, .bottom)
            }
            previousNode = i
        }
    }
    
    func addPadding() {
        let wow = calculateAccumulatedFrame().size.width * 0.1 * (1/CGFloat(items))
        for i in 0..<children.count {
            children[i].position.y -= wow * CGFloat(i)
        }
    }
    
    func leftAlign() {
        for i in children {
            i.place(.left, on: .zero, .right)
        }
    }
    func rightAlign() {
        for i in children {
            i.place(.right, on: .zero, .left)
        }
    }
    
    public override init() {
        super.init()
    }
    
    open override func copy() -> Any {
        return VStack.init(children.map { $0.copied })
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
