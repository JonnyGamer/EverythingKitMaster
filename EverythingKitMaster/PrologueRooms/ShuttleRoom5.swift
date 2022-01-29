//
//  ShuttleRoom5.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/29/22.
//

class ShuttleRoom5: SpeakerScene {
    
    override var peopleToSpeakWith: [SuperCharacters : Communication] { [
        
        .base(.roboto): .message(["foo"]),
        .from(.roboto, 1): .message(["foo"]),
        .from(.roboto, 2): .message(["foo"]),
        .from(.roboto, 3): .message(["foo"]),
        
        .base(.door) : .goto(["Enter?"], ShuttleRoom2.self, incomingFrom: .left, startPosition: (4259, 5129)),
        .from(.door, 1): .goto(["Enter?"],  ShuttleRoom6.self, incomingFrom: .right, startPosition: (0, 0) ),
        //.door: .lon
    ] }
}
