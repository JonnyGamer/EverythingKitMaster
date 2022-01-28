//
//  SKActionExtensions.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit
//#if os(macOS)
//typealias UIColor = NSColor
//#endif

extension SKAction {
    static func custom(duration: Double,_ action: @escaping (CGFloat) -> ()) -> SKAction {
        return .customAction(withDuration: duration) { _, j in
            action(j / CGFloat(duration))
        }
    }
}

extension SKAction {
    static func change(from: CGFloat, to: CGFloat, duration: Double, action: @escaping (CGFloat) -> ()) -> SKAction {
        .customAction(withDuration: duration, actionBlock: { _, j in
            let d = from + (to - from) * j / CGFloat(duration)
            action(d)
        })
    }
    
    static func fillColor(from: (r: CGFloat, g: CGFloat, b: CGFloat), to: (r: CGFloat, g: CGFloat, b: CGFloat), rgb: Bool, duration: Double) -> SKAction {
        .customAction(withDuration: duration, actionBlock: { i, j in
            let rinseR = from.r + (to.r - from.r) * j / CGFloat(duration)
            let rinseG = from.g + (to.g - from.g) * j / CGFloat(duration)
            let rinseB = from.b + (to.b - from.b) * j / CGFloat(duration)
            if rgb {
                (i as? SKShapeNode)?.fillColor = .init(red: rinseR, green: rinseG, blue: rinseB, alpha: 1.0)
            } else {
                (i as? SKShapeNode)?.fillColor = .init(hue: rinseR, saturation: rinseG, brightness: rinseB, alpha: 1.0)
            }
        })
    }
}

extension SKAction {
    static func speakingAnimation(words: String, sound: [SKAction], anim1: String, anim2: String) -> SKAction {
        return SKAction.group([
            .sequence(sound), // sequences apparently cannot be emtpy
            SKAction.sequence([
                SKAction.repeat(
                    SKAction.animate(with: [
                        SKTexture.init(imageNamed: anim1),
                        SKTexture.init(imageNamed: anim2),
                        //SKTexture.init(imageNamed: "InkyStandsOnTheSign2"),
                    //SKTexture.init(imageNamed: "InkyWalk3"),
                    ], timePerFrame: 0.1),
                    count: words.count/4
                ),
            ])
        ])
    }
}
