//
//  ShuttleRoom3.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/29/22.
//

import Foundation

class ShuttleRoom3: SpeakerScene {
    
    override var peopleToSpeakWith: [SuperCharacters : Communication] { [
        
        .base(.roboto): .long([
            .message(["Welcome to the Backup Room."]),
            .message(["We're definetely not trying","to deploy anything soon!"]),
        ]),
        
        .from(.roboto, 1): .long([
            .message(["My brothers and sisters.", "Soon they will be awake!"])
        ]),
        
        .base(.door) : .goto(["Enter door?"], ShuttleRoom2.self, incomingFrom: .bottom, startPosition: (340, 5540))
        
    ] }
}
