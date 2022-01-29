//
//  ShuttleRoom4.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/29/22.
//


class ShuttleRoom4: SpeakerScene {
    
    override var peopleToSpeakWith: [SuperCharacters : Communication] { [
        
        .base(.roboto): .long([
            .message(["Look at the planet we are orbiting"]),
            .message(["Blimey!"]),
        ]),
        
        .base(.door) : .goto(["Enter door?"], ShuttleRoom2.self, incomingFrom: .bottom, startPosition: (1880, 5540))
    ] }
}
