//
//  ShuttleRoom1.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/29/22.
//

import SpriteKit

class ShuttleRoom1: SpeakerScene {
    
    override var peopleToSpeakWith: [SuperCharacters : Communication] { [
        .base(.roboto): .long([
            .message(["What are you doing in here?"]),
            .message(["This is the storage room."]),
            .message(["The Captain is calling for you.","Best visit him now."]),
        ]),
        
        .base(.door): .long([
            .goto(["Enter door?"], ShuttleRoom2.self, incomingFrom: .top, startPosition: (-20, -120))
        ])
    ] }
    
    public override func began() {
        background.color = .white
        setupScene(self, startPosition: (34, 23))
    }
    
}
