//
//  SpeakerScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

protocol SpeakerScene {
    var backgroundMusic: MusicType { get }
    var peopleToSpeakWith: [SuperCharacters:Communication] { get }
    
    
}
extension SpeakerScene {
    func talkingAnimation(_ person: String, talkingOver: String) -> SKAction {
        print(person)
        guard let character = Characters.init(rawValue: person) else { fatalError() }
        let animation = character.animation()
        return .speakingAnimation(words: talkingOver, sound: character.sound(over: talkingOver), anim1: animation.0, anim2: animation.1)
    }
    
    func setupScene(_ scene: Scene) {
        Music.o.playMusic(backgroundMusic.rawValue)
        
    }
    
}
