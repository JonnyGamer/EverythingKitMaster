//
//  BasicTypeExtensions.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

extension Array where Element == String {
    var convertedToString: String {
        var wow = reduce("") { $0 + $1 + "\n" }
        wow.removeLast()
        return wow
    }
    var numberOfLetters: Int {
        return convertedToString.filter({ $0.isLetter }).count
    }
}
extension String {
    var inkySoundAnimation: [SKAction] {
        var sounds: [SKAction] = []
        let soundFile = SKAction.playSoundFileNamed("InkySpeaks5.m4a", waitForCompletion: false)
        let soundFile2 = SKAction.playSoundFileNamed("InkySpeaks6.m4a", waitForCompletion: false)
        //let soundFile3 = SKAction.playSoundFileNamed("InkySpeak3.m4a", waitForCompletion: false)
        let wait = SKAction.wait(forDuration: 0.05)
        for i in self {
            if i.isLetter {
                if "AEIOUYaeiouy".contains(i) {
                    sounds.append(soundFile2)
                } else {
                    sounds.append(soundFile)
                }
                sounds.append(wait)
            } else {
                sounds.append(wait)
            }
        }
        return sounds
    }
}
