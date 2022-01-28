//
//  RootScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

open class RootScene: SKScene {
    
    open var currentScene: Scene!
    open var startingScene: Scene!
    public init(size: CGSize, startingScene: Scene) {
        self.startingScene = startingScene
        super.init(size: size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        present(startingScene)
        backgroundColor = startingScene.background.color
        startingScene = nil
    }
    
    public override func tapped(tile: Tilable) {
        currentScene.tapped(tile: tile)
    }
    
    open var nodesTouched: [SKNode] = []
    open var touchBeganAt: CGPoint = .zero
    
    #if os(macOS)
    public override func mouseDown(with event: NSEvent) {
        if currentScene.action(forKey: "present") != nil { return }
        super.mouseDown(with: event)
        touchBeganAt = event.location(in: self)
        touchBeganAt = event.location(in: self)
        nodesTouched = nodes(at: touchBeganAt)
        nodesTouched.touchBegan()
        currentScene.touchBegan()
    }
    public override func mouseUp(with event: NSEvent) {
        if currentScene.action(forKey: "present") != nil { return }
        super.mouseUp(with: event)
        let nodesEndedOn = Set(nodes(at: event.location(in: self))).intersection(nodesTouched)
        Array(nodesEndedOn).touchEndedOn()
        nodesTouched.touchReleased()
        swiped(CGVector.init(dx: event.location(in: self).x - touchBeganAt.x, dy: event.location(in: self).y - touchBeganAt.y))
        currentScene.touchEnded()
    }
    #endif
    
    #if os(iOS)
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentScene.action(forKey: "present") != nil { return }
        super.touchesBegan(touches, with: event)
        let loc = touches.first?.location(in: self) ?? .zero
        touchBeganAt = loc
        nodesTouched += nodes(at: loc)
        nodesTouched.touchBegan()
        currentScene.touchBegan()
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentScene.action(forKey: "present") != nil { return }
        super.touchesEnded(touches, with: event)
        let loc = touches.first?.location(in: self) ?? .zero
        let nodesEndedOn = Set(nodes(at: loc)).intersection(nodesTouched)
        Array(nodesEndedOn).touchEndedOn()
        nodesTouched.touchReleased()
        swiped(CGVector.init(dx: loc.x - touchBeganAt.x, dy: loc.y - touchBeganAt.y))
        currentScene.touchEnded()
        if touches.count == 1 {
            nodesTouched = []
        }
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentScene.action(forKey: "present") != nil { return }
        super.touchesCancelled(touches, with: event)
        let loc = touches.first?.location(in: self) ?? .zero
        let nodesEndedOn = Set(nodes(at: loc)).intersection(nodesTouched)
        Array(nodesEndedOn).touchEndedOn()
        nodesTouched.touchReleased()
        swiped(CGVector.init(dx: loc.x - touchBeganAt.x, dy: loc.y - touchBeganAt.y))
        currentScene.touchEnded()
        if touches.count == 1 {
            nodesTouched = []
        }
    }
    #endif
    
    public func swiped(_ dxdy: CGVector) {
        currentScene.swiped(direction: dxdy)
    }
    
    public func present(_ node: Scene, fade: Bool, duration: Double = 0.5) {
//        
//        nodesTouched = []
//        node.began()
//        
//        var scaleTo: CGFloat = 0.5
//        var moveTo: CGPoint = .midScreen.half
//        var moveFrom: CGPoint = .midScreen.half
//        switch incomingFrom {
//        case .center: do{}
//        case .left: moveTo.x = w; moveFrom.x = -w
//        case .right: moveTo.x = -w; moveFrom.x = w
//        case .bottom: moveTo.y = h; moveFrom.y = -h
//        case .top: moveTo.y = -h; moveFrom.y = h
//        case .instant: scaleTo = 1.0; moveTo = .zero; moveFrom = .zero// do{}
//        }
//        
//        if let currentScene = currentScene {
//            
//            currentScene.run(.group([
//                .scale(to: scaleTo, duration: duration).easeInEaseOut(),
//                .move(to: moveTo, duration: duration).easeInEaseOut(),
//                .fadeAlpha(to: 0.0, duration: duration)//.easeInEaseOut()
//            ])) {
//                currentScene.removeFromParent()
//                currentScene.removeEveryChild()
//            }
//        }
//        
//        currentScene = node
//        
//        node.setScale(scaleTo)
//        node.position = moveFrom//.midScreen.half
//        node.alpha = 0.0
//        node.run(.group([
//            .scale(to: 1.0, duration: duration).easeInEaseOut(),
//            .move(to: .zero, duration: duration).easeInEaseOut(),
//            .fadeAlpha(to: 1.0, duration: duration)//.easeInEaseOut()
//        ]), withKey: "present")
//        addChild(node)
        
    }
    
    public func present(_ node: Scene, incomingFrom: Incoming = .center, duration: Double = 0.5) {
        
        nodesTouched = []
        node.began()
        
        var scaleTo: CGFloat = 0.5
        var moveTo: CGPoint = .midScreen.half
        var moveFrom: CGPoint = .midScreen.half
        switch incomingFrom {
        case .center: do{}
        case .left: moveTo.x = w; moveFrom.x = -w
        case .right: moveTo.x = -w; moveFrom.x = w
        case .bottom: moveTo.y = h; moveFrom.y = -h
        case .top: moveTo.y = -h; moveFrom.y = h
        case .instant: scaleTo = 1.0; moveTo = .zero; moveFrom = .zero// do{}
        }
        
        if let currentScene = currentScene {
            
            currentScene.run(.group([
                .scale(to: scaleTo, duration: duration).easeInEaseOut(),
                .move(to: moveTo, duration: duration).easeInEaseOut(),
                .fadeAlpha(to: 0.0, duration: duration)//.easeInEaseOut()
            ])) {
                currentScene.removeFromParent()
                currentScene.removeEveryChild()
            }
        }
        
        currentScene = node
        
        node.setScale(scaleTo)
        node.position = moveFrom//.midScreen.half
        node.alpha = 0.0
        node.run(.sequence([
            .group([
                .scale(to: 1.0, duration: duration).easeInEaseOut(),
                .move(to: .zero, duration: duration).easeInEaseOut(),
                .fadeAlpha(to: 1.0, duration: duration),//.easeInEaseOut()
            ]),
            .run {
                self.currentScene.movedToView()
            }
        ]), withKey: "present")
        
        addChild(node)

    }

}

extension SKNode {
    func removeEveryChild() {
        for i in children {
            i.removeEveryChild()
        }
        if children.isEmpty {
            removeFromParent()
        }
    }
}

