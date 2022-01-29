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
    
    // GameControllerKit
    var hardnessX: CGFloat?
    var hardnessY: CGFloat?
    var keysDown: Set<_Keys> = []
    func pressedA() { currentScene.pressedA() }
    func stoppedPressingA() {}
    
    var joyPosition: CGPoint = .zero
    var supperRadius: CGFloat = .zero
    var theJoyStick: SKSpriteNode!
    var theJoyPad: SKSpriteNode!
    func startJoyStick(to: CGPoint) {
        theJoyStick.fadeIn()
    }
    func resetJoyStick() {
        if theJoyStick == nil { return }
        theJoyStick.run(.move(to: joyPosition, duration: 0.1))
        keysDown.remove(.rightArrow)
        keysDown.remove(.leftArrow)
        keysDown.remove(.upArrow)
        keysDown.remove(.downArrow)
    }
    
    var aButton: SKNode?
    func canPressA() {
        let foo = SKSpriteNode.init(imageNamed: "A_Button")
        aButton = foo
        foo.keepInside(.hundred.times(2))
        addChild(foo)
        //foo.place(.right, on: .screen, .right)
        //foo.place(.bottom, on: .screen, .bottom)
        foo.centerAt(x: w)
        foo.centerAt(y: 0)
        foo.position.x -= (foo.size.width)
        foo.position.y += (foo.size.height)
        foo.fadeIn()
        foo.zPosition = 10000
    }
    
    func cannotPressA() {
        aButton?.fadeOutGoodBye()
        aButton = nil
    }
    
    // BoardKit
    public override func tapped(tile: Tilable) {
        currentScene.tapped(tile: tile)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        present(startingScene)
        backgroundColor = startingScene.background.color
        startingScene = nil
    }
    open override func update(_ currentTime: TimeInterval) {
        currentScene.update()
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
        
        if (currentScene as? SpeakerScene) != nil {
            if theJoyStick != nil {
                startJoyStick(to: touchBeganAt)//theJoyStick.fadeIn()
                usedMouse = true
                if theJoyPad.alpha == 0 {
                    theJoyPad.fadeIn()
                }
            }
        }
        
        touchMoved(loc: event.location(in: self))
    }
    open override func addChild(_ node: SKNode) {
        super.addChild(node)
        print("foo")
    }
    
    public override func mouseUp(with event: NSEvent) {
        if currentScene.action(forKey: "present") != nil { return }
        super.mouseUp(with: event)
        let nodesEndedOn = Set(nodes(at: event.location(in: self))).intersection(nodesTouched)
        Array(nodesEndedOn).touchEndedOn()
        nodesTouched.touchReleased()
        swiped(CGVector.init(dx: event.location(in: self).x - touchBeganAt.x, dy: event.location(in: self).y - touchBeganAt.y))
        currentScene.touchEnded()
        
        resetJoyStick()
    }
    open override func mouseDragged(with event: NSEvent) {
        let loc = event.location(in: self)
        touchMoved(loc: loc)
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
    
    func touchMoved(loc: CGPoint) {
        guard let theJoyStick = theJoyStick else { return }
        
        theJoyStick.position = loc
        
        let newPosition = loc
        let ddx = joyPosition.x - newPosition.x
        let ddy = joyPosition.y - newPosition.y
        let distance = sqrt((ddx * ddx) + (ddy * ddy))
        
        let realX = (newPosition.x - joyPosition.x) / supperRadius
        let realY = (newPosition.y - joyPosition.y) / supperRadius
        
        if abs(realX) > 0.2 {
            hardnessX = min(1.0, abs(realX))
            if realX > 0 {
                keysDown.insert(.rightArrow)
            } else {
                keysDown.insert(.leftArrow)
            }
        } else {
            keysDown.remove(.rightArrow)
            keysDown.remove(.leftArrow)
        }
        if abs(realY) > 0.2 {
            hardnessY = min(1.0, abs(realY))
            if realY > 0 {
                keysDown.insert(.upArrow)
            } else {
                keysDown.insert(.downArrow)
            }
        } else {
            keysDown.remove(.upArrow)
            keysDown.remove(.downArrow)
        }
        
        if distance > supperRadius {
            let angle = atan((newPosition.y - joyPosition.y)/(newPosition.x - joyPosition.x)) * (180.0 / .pi)
            let newVector = pointOnACircle(angle: Double(angle))
            
            if newPosition.x < joyPosition.x {
                theJoyStick.position.x = joyPosition.x + (supperRadius * newVector.dx * -1)
                theJoyStick.position.y = joyPosition.y + (supperRadius * newVector.dy * -1)
            } else {
                theJoyStick.position.x = joyPosition.x + (supperRadius * newVector.dx)
                theJoyStick.position.y = joyPosition.y + (supperRadius * newVector.dy)
            }
        }
    }
    
    public func swiped(_ dxdy: CGVector) {
        currentScene.swiped(direction: dxdy)
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
                self.cannotPressA()
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

