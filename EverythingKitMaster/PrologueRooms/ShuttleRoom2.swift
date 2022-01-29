//
//  ShuttleRoom2.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/29/22.
//

class ShuttleRoom2: SpeakerScene {
    
    //override var backgroundMusic: MusicType { "" }
    
    override var peopleToSpeakWith: [SuperCharacters : Communication] { [
        
        .base(.roboto): .long([
            .message(["This spot is different."]),
            .message(["I'll have to call the","janitor again."]),
        ]),
        
        .from(.roboto, 1): .long([
            .message(["Come on!", "Go up there and to the right!"])
        ]),
        
        .base(.door) : .goto(["Enter door?"], ShuttleRoom3.self, incomingFrom: .top, startPosition: (50, 230)),
        .from(.door, 1) : .goto(["Enter door?"], ShuttleRoom4.self, incomingFrom: .top, startPosition: (30, 210)),
        .from(.door, 2) : .goto(["Enter door?"], ShuttleRoom5.self, incomingFrom: .right, startPosition: (30, -220)),
        .from(.door, 3) : .goto(["Enter door?"], ShuttleRoom1.self, incomingFrom: .bottom, startPosition: (44, 1363)), // , startingPos: CGPoint(x: 70, y: 1450)
        
    ] }
    
}
