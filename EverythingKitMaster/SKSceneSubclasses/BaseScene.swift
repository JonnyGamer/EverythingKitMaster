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
    
    func pressedA() {
        if chatBox == nil {
            if let s = (self as? SpeakerScene)?.canSpeakWith, let message = (self as? SpeakerScene)?.peopleToSpeakWith[s.char] {
    
                let woah = DispatchQueue.init(label: "")
                woah.async { [self] in
                    self.message(message)
                }
                
            }
        } else {
            chatBox?.next()
        }
    }
    
    public required init(_ screenSize: CGSize = CGSize.init(width: w, height: h)) {
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
    
    public func update() {}
    public func touchBegan() {}
    public func touchEnded() {}
    public func began() {}
    public func movedToView() {}
    public func tapped(tile: Tilable) {}
    public func swiped(direction: CGVector) {}
    public func present(_ node: Scene.Type, incomingFrom: Incoming = .center, duration: Double = 0.5) {
        (scene as? RootScene)?.present(node.init(), incomingFrom: incomingFrom, duration: duration)
    }
//    public func present(_ node: Scene.Type, fade: Bool, duration: Double = 0.5) {
//        (scene as? RootScene)?.present(node.init(), fade: fade, duration: duration)
//    }
    func pressedKey(_ key: Keys) {}
    func _onKeyDown(_ key: Keys) {
        if key == .up {
            chatBox?.moveSelection(1)
        } else if key == .down {
            chatBox?.moveSelection(-1)
        }
    }
    
    func onKeyDown(_ key: Keys) {}
    
    
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
