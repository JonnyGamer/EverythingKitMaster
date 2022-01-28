//
//  ToggleKit.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

class Toggle: SKNode, SuperTouchable {
    
    var _toggling: Bool = false
    
    enum ToggleColor {
        case green
        case blue
        case red
        case yellow
        func color() -> (CGFloat, CGFloat, CGFloat) {
            switch self {
            case .green: return (0.1, 0.9, 0.1)
            case .blue: return (0.1, 0.1, 0.9)
            case .red: return (0.9, 0.1, 0.1)
            case .yellow: return (0.9, 0.9, 0.1)
            }
        }
    }
    var toggleColor: (r: CGFloat, g: CGFloat, b: CGFloat) = (0.1, 0.9, 0.1)
    
    func _touchBegan() {
        if _toggling { return }
        _toggling = true
        
        self.__on.toggle()
        
        if self.__on {
            circle.centerAt(x: buttonWidth/5)
            let newX = circle.position.x
            circle.centerAt(x: -buttonWidth/5)
            circle.run(.moveTo(x: newX, duration: 0.1).easeInEaseOut()) {
                //self.circle.fillColor = .green
                self._toggling = false
            }
            
            shape.run(.fillColor(from: (0.9, 0.9, 0.9), to: toggleColor, rgb: true, duration: 0.1))
            //circle.run(.fillColor(from: (0.7, 0.7, 0.7), to: (0.1, 0.9, 0.1), rgb: true, duration: 0.1))
            
            
        } else {
            circle.centerAt(x: -buttonWidth/5)
            let newX = circle.position.x
            circle.centerAt(x: buttonWidth/5)
            circle.run(.moveTo(x: newX, duration: 0.1).easeInEaseOut()) {
                //self.circle.fillColor = .init(white: 0.7, alpha: 1.0)
                self._toggling = false
            }
            shape.run(.fillColor(from: toggleColor, to: (0.9, 0.9, 0.9), rgb: true, duration: 0.1))
            //circle.run(.fillColor(from: (0.1, 0.9, 0.1), to: (0.7, 0.7, 0.7), rgb: true, duration: 0.1))
        }
        
        touchBegan(self)
    }
    
    func _touchReleased() {}
    func _touchEndedOn() {}
    var touchBegan: (Toggle) -> () = {_ in}
    var touchReleased: (Toggle) -> () = {_ in}
    var touchEndedOn: (Toggle) -> () = {_ in}
    
    var buttonWidth: CGFloat
    var shape: SKShapeNode
    var circle: SKShapeNode
    var __on: Bool
    
    init(default: Bool, height: CGFloat, color: ToggleColor = .green) {
        let buttonWidth = height * 1.5
        
        self.buttonWidth = buttonWidth
        self.toggleColor = color.color()
        
        shape = SKShapeNode.init(rectOf: .init(width: buttonWidth, height: buttonWidth/1.5), cornerRadius: buttonWidth/3)
        shape.fillColor = .init(white: 0.9, alpha: 1.0)
        
        circle = SKShapeNode.init(circleOfRadius: buttonWidth/4)
        circle.fillColor = .white
        
        self.__on = `default`
        
        super.init()
        
        
        if `default` {
            shape.fillColor = .init(red: toggleColor.r, green: toggleColor.g, blue: toggleColor.b, alpha: 1.0)
            circle.centerAt(x: buttonWidth/5)
        } else {
            shape.fillColor = .init(white: 0.9, alpha: 1.0)
            circle.centerAt(x: -buttonWidth/5)
        }
        
        self.addChild(shape)
        shape.addChild(circle)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class SavedToggle: Toggle {
//    
//    @UserDefault(key: "", defaultValue: false)
//    var on: Bool
//    
//    override func _touchBegan() {
//        if _toggling { return }
//        _toggling = true
//        
//        self.on.toggle()
//        
//        if self.on {
//            circle.centerAt(x: buttonWidth/5)
//            let newX = circle.position.x
//            circle.centerAt(x: -buttonWidth/5)
//            circle.run(.moveTo(x: newX, duration: 0.1).easeInEaseOut()) {
//                self.circle.fillColor = .green
//                self._toggling = false
//            }
//            circle.run(.fillColor(from: (0.7, 0.7, 0.7), to: (0.1, 0.9, 0.1), duration: 0.1))
//            
//        } else {
//            circle.centerAt(x: -buttonWidth/5)
//            let newX = circle.position.x
//            circle.centerAt(x: buttonWidth/5)
//            circle.run(.moveTo(x: newX, duration: 0.1).easeInEaseOut()) {
//                self.circle.fillColor = .init(white: 0.7, alpha: 1.0)
//                self._toggling = false
//            }
//            circle.run(.fillColor(from: (0.1, 0.9, 0.1), to: (0.7, 0.7, 0.7), duration: 0.1))
//        }
//        
//        touchBegan(self)
//    }
//    
//    init(name: String, default: Bool, height: CGFloat) {
//        
//        _on.defaultValue = `default`
//        _on.key = name
//        
//        super.init(default: `default`, height: height)
//        
//        if self.on {
//            circle.fillColor = .init(red: 0.1, green: 0.9, blue: 0.1, alpha: 1.0)
//            circle.centerAt(x: buttonWidth/5)
//        } else {
//            circle.fillColor = .init(white: 0.7, alpha: 1.0)
//            circle.centerAt(x: -buttonWidth/5)
//        }
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
