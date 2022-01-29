//
//  ShuttleRoom6.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/29/22.
//

class ShuttleRoom6: SpeakerScene {
    
    override var peopleToSpeakWith: [SuperCharacters : Communication] { [
        
        .base(.roboto): .message(["foo"]),
        .base(.jeffery): .message(["Wow!"]),
        .from(.jeffery, 1): .message(["Now don't get too comfortable"]),
        
        .base(.door) : .goto(["Enter?"], ShuttleRoom5.self, incomingFrom: .left, startPosition: (4330, -180)),
        //.door: .lon
    ] }
}

