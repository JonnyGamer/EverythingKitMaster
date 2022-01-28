//
//  BaseScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

public enum Incoming {
    case center, left, right, top, bottom, instant
}

open class Scene: SKNode {
    
    deinit {
        print("SEE YA CHUMP CHUMP")
    }
    
    @discardableResult func display(_ text: String, waitForReturn: Bool = false) -> String? {
        return nil
    }
    
    open var background: SKSpriteNode!
    open var forground: SKSpriteNode!
    open weak var _keyboard: SKNode?
    var uppercase = false
    var option = false
    var chatBox: ChatBox?
    
    public init(_ screenSize: CGSize = CGSize.init(width: w, height: h)) {
        self.background = SKSpriteNode.init(color: .white, size: .veryBig)
        background.zPosition = -.infinity
        
        self.forground = SKSpriteNode.init(color: .white, size: .veryBig)
        forground.zPosition = .infinity
        forground.alpha = 0
        
        super.init()
        addChild(background)
        addChild(forground)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func touchBegan() {}
    public func touchEnded() {}
    public func began() {}
    public func movedToView() {}
    public func tapped(tile: Tilable) {}
    public func swiped(direction: CGVector) {}
    public func present(_ node: Scene, incomingFrom: Incoming = .center, duration: Double = 0.5) {
        (scene as? RootScene)?.present(node, incomingFrom: incomingFrom, duration: duration)
    }
    public func present(_ node: Scene, fade: Bool, duration: Double = 0.5) {
        (scene as? RootScene)?.present(node, fade: fade, duration: duration)
    }
    func pressedKey(_ key: Keys) {}
    
}


public extension Scene {
    func zoom(to: CGFloat) {
        self.run(.scale(to: to, duration: 0.2).easeInEaseOut())
        self.run(.move(to: .midScreen.times(1 - to), duration: 0.2).easeInEaseOut())
    }
    func connectButton(_ button: SpriteButton) {
        button.touchBegan = { _ in
            self.zoom(to: 0.95)
        }
        button.touchReleased = { _ in
            self.zoom(to: 1.0)
        }
    }
}
