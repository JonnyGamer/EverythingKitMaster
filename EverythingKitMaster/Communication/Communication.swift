//
//  Communication.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/28/22.
//

import Foundation

enum Communication {
    case message([String])
    case long([Self])
    case multipleChoice([String], [([String], Self)])
    case run(() -> Communication)
    case exec(() -> ())
    case none
}

extension Communication {
    static func present(_ scene: Scene.Type, incomingFrom: Incoming = .center) -> Self {
        return .exec({
            root.present(scene.init(), incomingFrom: incomingFrom)
        })
    }
    
    static func goto(_ string: [String],_ scene: Scene.Type) -> Communication {
        return .multipleChoice(string, [
            (["yes"], .present(scene)),
            (["no"], .none),
        ])
    }
    
    static func playMusic<T: MusicType>(_ music: T) -> Communication {
        return .exec({
            Music.o.playMusic(MusicList.theIndustry)
        })
    }
    
}

extension Scene {
    
    func message(_ this: Communication, top: Bool = true) {
        
        func stillExists() -> Bool { return root.currentScene === self }
        
        if !stillExists() {
            print("OKAY")
            return
        }
        
        func wait() {
            while chatBox?._next == false || !stillExists() {}
        }
            
        switch this {
        case .message(let words):
            addChatBox(words: words, options: [])
            
        case .long(let newThis): do{}
            for i in newThis {
                wait()
                message(i, top: false)
            }
        
        case .multipleChoice(let words, let choices):
            addChatBox(words: words, options: choices)
            wait()
            message(chatBox!._result!, top: false)
            
        case .run(let this):
            message(this())
        case .exec(let this):
            this()
        case .none:
            do{}
            
        }
        
        if top {
            wait()
            removeOldChatBox()
        }
        
    }
}
