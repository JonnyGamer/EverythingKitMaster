//
//  SpeakerScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

protocol SpeakerScene {
    var peopleToSpeakWith: [SuperCharacters:SpeakerEnum] { get }
    func talkingAnimation(_ person: String, talkingOver: String) -> SKAction
}
extension SpeakerScene {
    func talkingAnimation(_ person: String, talkingOver: String) -> SKAction {
        print(person)
        guard let character = Characters.init(rawValue: person) else { fatalError() }
        let animation = character.animation()
        return .speakingAnimation(words: talkingOver, sound: character.sound(over: talkingOver), anim1: animation.0, anim2: animation.1)
    }
}
