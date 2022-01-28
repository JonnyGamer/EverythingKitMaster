//
//  ButtonKit.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

open class SpriteButton: SKNode, SuperTouchable {
    var touched = false
    
    var rgb = true
    var buttonColor: (CGFloat,CGFloat,CGFloat) = (1,0,0)
    var halfButtonColor: (CGFloat,CGFloat,CGFloat) {
        return rgb ? (buttonColor.0/2,buttonColor.1/2,buttonColor.2/2) : (buttonColor.0,buttonColor.1,buttonColor.2/2)
    }
    
    open func _touchBegan() {
        if touched { return }
        touched = true

        button.run(.fillColor(from: buttonColor, to: halfButtonColor, rgb: rgb, duration: 0.1))
        button.run(.moveBy(x: 0, y: offsetY, duration: 0.1).circleOut())
        touchBegan(self)
    }
    open func _touchReleased() {
        if !touched { return }
        touched = false
        button.run(.fillColor(from: halfButtonColor, to: buttonColor, rgb: rgb, duration: 0.1))
        button.run(.moveBy(x: 0, y: -offsetY, duration: 0.1).circleOut())
        touchReleased(self)
    }
    open func _touchEndedOn() {
        if !touched { return }
        touched = false
        button.run(.fillColor(from: halfButtonColor, to: buttonColor, rgb: rgb, duration: 0.1))
        button.run(.moveBy(x: 0, y: size.times(0.1).height, duration: 0.1).circleOut())
        touchEndedOn(self)
    }
    open var touchBegan: (SpriteButton) -> () = { _ in }
    open var touchReleased: (SpriteButton) -> () = { _ in }
    open var touchEndedOn: (SpriteButton) -> () = { _ in }

    open var size: CGSize
    open var button: SKNode
    open var buttonShadow: SKNode
    open var offsetY: CGFloat { -size.times(0.1).height }
    
    open override func copy() -> Any {
        return SpriteButton.init(size: size, button: button.copied, buttonShadow: buttonShadow.copied)
    }
    
    private init(size: CGSize, button: SKNode, buttonShadow: SKNode) {
        self.size = size
        self.button = button
        self.buttonShadow = buttonShadow
        super.init()
    }
    
    public init(size: CGSize, fillColor: (CGFloat,CGFloat,CGFloat) = (1,1,1), rgb: Bool = true) {
        self.rgb = rgb
        let foo = SKShapeNode.init(rectOf: size, cornerRadius: min(size.width, size.height)/4)// SKSpriteNode.init(color: color, size: size)
        
        if rgb {
            foo.fillColor = .init(red: fillColor.0, green: fillColor.1, blue: fillColor.2, alpha: 1.0)
        } else {
            foo.fillColor = .init(hue: fillColor.0, saturation: fillColor.1, brightness: fillColor.2, alpha: 1.0)
        }
        
        
        buttonColor = fillColor
        foo.strokeColor = .black
        foo.lineWidth = min(size.width, size.height)/25
        button = foo
        self.size = size
        let wo = foo.copied
        buttonShadow = wo
        wo.strokeColor = .clear
        super.init()
        
        _ = wo.then {
            $0.fillColor = .black
            $0.position.y += offsetY
            //$0.zPosition = -2
            $0.alpha = 0.2
        }
        
        addChild(buttonShadow)
        addChild(button)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


public extension SpriteButton {
    func addText(_ text: [String]) {
        let foo1 = Paragraph.init(text) {
            $0.bold()
            $0.setScale(4.0)
            $0.unpixelate()
            $0.fontColor = .black
        }
        foo1.keepInside(size.times(0.8))
        foo1.centerAt(point: position)
        button.addChild(foo1)
    }
}

public extension Scene {
    func Button(_ text: String, size: CGSize, connect: Bool = true, touchEnded: @escaping () -> ()) -> SpriteButton {
        SpriteButton.init(size: size).then({
            $0.addText([
                text
            ])
            if connect {
                self.connectButton($0)
            }
            $0.touchEndedOn = { _ in
                touchEnded()
            }
        })
    }
}
