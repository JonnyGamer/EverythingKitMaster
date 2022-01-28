//
//  KeyboardKit.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

public enum Keys: String, CaseIterable {
    case caps
    case shift
    case `return`
    case tab
    case backtick = "`", one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", zero = "0", minus = "-", equal = "=", delete = "⌫"
    
    case q, w, e, r, t, y, u, i, o, p, openSquare = "[", closeSquare = "]", backslash = "\\"
    case a, s, d, f, g, h, j, k, l, semicolon = ";", apostrophe = "'"
    case z, x, c, v, b, n, m, comma = ",", period = ".", slash = "/"
    case fn = "⌨︎", cntrl = "⌃", option = "⌥", cmd = "⌘", space = " ", left = "←", up = "↑", down = "↓", right = "→"
    
    case star = "*", sqrt = "√", plus = "+"
    
    static var letters: [Self] = [
        .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero,
        .q, .w, .e, .r, .t, .y, .u, .i, .o, .p, .a, .s, .d, .f, .g, .h, .j, .k, .l, .z, .x, .c, .v, .b, .n, .m,
        .space
    ]
    
    func canBeTyped() -> Bool {
        return Self.letters.contains(self)
    }
    func trueValue() -> String {
        if !root.currentScene.uppercase, !root.currentScene.option { return rawValue }
        if root.currentScene.uppercase, !root.currentScene.option { return uppercased() }
        if !root.currentScene.uppercase, root.currentScene.option { return optioned() }
        if root.currentScene.uppercase, root.currentScene.option { return optionShifted() }
        fatalError()
    }
    
    func optionShifted() -> String {
        let wow = Self.allCases.firstIndex(of: self)!
        return ["", "", "", "", "`", "⁄", "€", "‹", "›", "ﬁ", "ﬂ", "‡", "°", "·", "‚", "—", "±", "",
            "Œ", "„", "´", "‰", "ˇ", "Á", "¨", "ˆ", "Ø", "∏", "”", "’", "»",
            "Å", "Í", "Î", "Ï", "˝", "Ó", "Ô", "", "Ò", "Ú", "Æ",
            "¸", "˛", "Ç", "◊", "ı", "˜", "Â", "¯", "˘", "¿"
        ][wow]
    }
    func optioned() -> String {
        let wow = Self.allCases.firstIndex(of: self)!
        return ["", "", "", "", "`", "¡", "™", "£", "¢", "∞", "§", "¶", "•", "ª", "º", "–", "≠", "",
            "œ", "∑", "´", "®", "†", "¥", "¨", "ˆ", "ø", "π", "“", "‘", "«",
            "å", "ß", "∂", "ƒ", "©", "˙", "∆", "˚", "¬", "…", "æ",
            "Ω", "≈", "ç", "√", "∫", "˜", "µ", "≤", "≥", "÷"
        ][wow]
    }
    
    func uppercased() -> String {
        switch self {
        case .backtick: return "~"
        case .one: return "!"
        case .two: return "@"
        case .three: return "#"
        case .four: return "$"
        case .five: return "%"
        case .six: return "^"
        case .seven: return "&"
        case .eight: return "*"
        case .nine: return "("
        case .zero: return ")"
        case .minus: return "_"
        case .equal: return "+"
        case .comma: return "<"
        case .period: return ">"
        case .slash: return "?"
        case .semicolon: return ":"
        case .apostrophe: return "\""
        case .openSquare: return "{"
        case .closeSquare: return "}"
        case .backslash: return "|"
        default: return rawValue.uppercased()
        }
    }
}

public enum KeyboardType {
    case complete, numberPad//, arrowPad, letterPad
}

public extension Scene {
    
    func keyBoard(_ keyboardType: KeyboardType) -> SKNode {
        
        var keyboardStack: VStack!
        
        func l(_ key: Keys) -> SpriteButton {
            
            //←↑→↓⌥⌘⌫ ⇧⇪⌃
            switch key {
            case .shift:
                return Button(key.rawValue, size: .init(width: 225, height: 100), connect: false) {
                    self.uppercase.toggle()
                    self.putAwayKeyboard(instant: true)
                    self.bringUpKeyboard(instant: true, keyboardType)
                }
            case .caps: return Button(key.rawValue, size: .init(width: 175, height: 100), connect: false) {}
            case .return:
                if keyboardType == .complete {
                    return Button(key.rawValue, size: .init(width: 175, height: 100), connect: false) { self.pressedKey(key) }
                } else if keyboardType == .numberPad {
                    return Button("Enter", size: .init(width: 200, height: 100), connect: false) { self.pressedKey(key) }
                }
                
            case .delete:
                if keyboardType == .complete {
                    return Button(key.rawValue, size: .init(width: 150, height: 100), connect: false) { self.pressedKey(key) }
                } else if keyboardType == .numberPad {
                    return Button(key.rawValue, size: .hundred, connect: false) { self.pressedKey(key) }
                }
                
            case .tab: return Button(key.rawValue, size: .init(width: 150, height: 100), connect: false) {}
            case .cmd: return Button(key.rawValue, size: .init(width: 120, height: 100), connect: false) {}
            case .up: return Button(key.rawValue, size: .init(width: 100, height: 50), connect: false) { self.pressedKey(key) }
            case .down: return Button(key.rawValue, size: .init(width: 100, height: 50), connect: false) { self.pressedKey(key) }
            case .left: return Button(key.rawValue, size: .init(width: 100, height: 100), connect: false) { self.pressedKey(key) }
            case .right: return Button(key.rawValue, size: .init(width: 100, height: 100), connect: false) { self.pressedKey(key) }
            case .option: return Button(key.rawValue, size: .init(width: 150, height: 100), connect: false) {
                self.option.toggle()
                self.putAwayKeyboard(instant: true)
                self.bringUpKeyboard(instant: true, keyboardType)
            }
            case .fn:
                if keyboardType == .complete {
                    return Button(key.rawValue, size: .init(width: 300, height: 100), connect: false) {
                        self.putAwayKeyboard()
                    }
                } else if keyboardType == .numberPad {
                    return Button(key.rawValue, size: .hundred, connect: false) {
                        self.putAwayKeyboard()
                    }
                }
                
            case .space: return Button(key.rawValue, size: .init(width: 900, height: 100), connect: false) {
                self.pressedKey(key)
            }
                
            default:
                if keyboardType == .numberPad, key == .zero {
                    return Button("0", size: .init(width: 200, height: 100), connect: false) { self.pressedKey(key) }
                }
                
                var str = key.rawValue
                if uppercase, !option { str = key.uppercased() }
                if !uppercase, option { str = key.optioned() }
                if uppercase, option { str = key.optionShifted() }
                
                return Button(str, size: .hundred, connect: false) { self.pressedKey(key) }
            }
            
            fatalError()
        }
        
        if keyboardType == .complete {
            
            let topRow: HStack = HStack([
                l(.backtick), l(.one), l(.two), l(.three), l(.four), l(.five),
                l(.six), l(.seven), l(.eight), l(.nine), l(.zero), l(.minus), l(.equal), l(.delete)
            ])
            let midTopRow: HStack = HStack([
                l(.option), l(.q), l(.w), l(.e), l(.r), l(.t), l(.y), l(.u), l(.i), l(.o), l(.p),
                l(.openSquare), l(.closeSquare), l(.backslash)
            ])
            let middleRow: HStack = HStack([
                l(.return), l(.a), l(.s), l(.d), l(.f), l(.g), l(.h), l(.j), l(.k), l(.l), l(.semicolon), l(.apostrophe), l(.return),
            ])
            let bottomRow: HStack = HStack([
                l(.shift), l(.z), l(.x), l(.c), l(.v), l(.b), l(.n), l(.m), l(.comma), l(.period), l(.slash), l(.shift)
            ])
            let upDownArrows: VStack = VStack([
                l(.up),
                l(.down)
            ])
            let realBottomRow: HStack = HStack([
                l(.fn),/* l(.cntrl), l(.option), l(.cmd), */l(.space), /*l(.cmd), l(.option),*/ l(.left), upDownArrows, l(.right)
            ])
            
            keyboardStack = VStack.init([
                topRow,
                midTopRow,
                middleRow,
                bottomRow,
                realBottomRow
            ])
            
        }
        
        if keyboardType == .numberPad {
            
            let topRow: HStack = HStack([
                l(.fn), l(.slash), l(.star), l(.sqrt)
            ])
            let midTopRow: HStack = HStack([
                l(.seven), l(.eight), l(.nine), l(.plus),
            ])
            let middleRow: HStack = HStack([
                l(.four), l(.five), l(.six), l(.minus)
            ])
            let bottomRow: HStack = HStack([
                l(.one), l(.two), l(.three), l(.delete)
            ])
            let bottomBottomRow: HStack = HStack([
                l(.zero), l(.return)
            ])
            
            keyboardStack = VStack.init([
                topRow,
                midTopRow,
                middleRow,
                bottomRow,
                bottomBottomRow
            ])
            
        }
        
        
        return keyboardStack
    }
    
    func bringUpKeyboard(instant: Bool = false,_ keyboardType: KeyboardType = .complete, completion: (() -> ())? = nil) {
        if !instant {
            uppercase = false
            option = false
        }
//        if let woah = _keyboard {
//            //woah.removeAllActions()
//            let saveSaveY = woah.position.y
//            woah.place(.bottom, on: .screen, .bottom)
//            woah.position.y += 20
//            let saveY = woah.position.y
//            woah.position.y = saveSaveY
//
//            woah.run(.sequence([
//                .moveTo(y: saveY, duration: 0.35).easeInEaseOut()
//            ]))
//            return
//        }
        
        let keyboard = keyBoard(keyboardType)
        keyboard.keepInside(.init(width: w, height: h*0.33))
        keyboard.centerAt(point: .zero)
        
        let woah = SKShapeNode.init(rectOf: keyboard.calculateAccumulatedFrame().size.times(1.1), cornerRadius: 50)
        _keyboard = woah
        woah.fillColor = .white
        woah.strokeColor = .black
        woah.lineWidth = 20
        woah.addChild(keyboard)
        woah.keepInside(.init(width: w*0.9, height: h*0.33))
        woah.centerAt(point: .midScreen)
        woah.place(.bottom, on: .screen, .bottom)
        woah.position.y += 20
        addChild(woah)
        if !instant {
            let saveY = woah.position.y
            woah.place(.top, on: .screen, .bottom)
            woah.run(.sequence([
                .moveTo(y: saveY, duration: 0.35).easeInEaseOut()
            ])) {
                completion?()
            }
        } else {
            completion?()
        }
    }
    func putAwayKeyboard(instant: Bool = false, completion: (() -> ())? = nil) {
        if instant { self._keyboard?.removeFromParent(); self._keyboard = nil }
        
        guard let keyboard = _keyboard else { return }
        self._keyboard = nil
        keyboard.place(.top, on: .screen, .bottom)
        let saveY = keyboard.position.y
        keyboard.place(.bottom, on: .screen, .bottom)
        keyboard.position.y += 20
        keyboard.run(.sequence([
            .moveTo(y: saveY, duration: 0.35).easeInEaseOut()
        ])) {
            keyboard.removeFromParent()
            completion?()
        }
    }
    
}
