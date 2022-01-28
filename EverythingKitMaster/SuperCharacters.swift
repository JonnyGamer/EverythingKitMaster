//
//  SuperCharacters.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

enum Characters: String {
    
    case sign = "Sign"
    case inkyStandingOnTheSign = "InkyStandsOnTheSign"
    case flyingInky = "InkyWithWings"
    
    case inkyTuckedInABasket = "InkyTuckedInABasket"
    case basketShop = "BasketShopkeeperInky"
    case beardedInky = "GeneralBeardInky"
    case inkyFollowingInsect = "InkyFollowingInsect"
    case inkyTakingASnooze = "InkyTakingASnooze"
    
    case roboto = "Roboto"
    case door = "Door"
    case jeffery = "JefferyHimself"
}

extension Characters {
    func animation() -> (String, String) {
        switch self {
        case .inkyStandingOnTheSign: return ("InkyStandsOnTheSign3", "InkyStandsOnTheSign")
        case .flyingInky: return (self.rawValue, self.rawValue)
        case .sign: return (self.rawValue, self.rawValue)
        case .inkyTuckedInABasket: return (self.rawValue, self.rawValue)
        default: return (self.rawValue, self.rawValue)
        }
    }
    func sound(over: String) -> [SKAction] {
        switch self {
        case .inkyStandingOnTheSign: return over.inkySoundAnimation
        //case .flyingInky: return over.inkySoundAnimation
        //case .sign: return over.inkySoundAnimation
        default: return over.inkySoundAnimation
        }
    }
}



//extension Scene {
//    func presentScene(_ scene: Scene.Type, point: CGPoint?) {
//        Scene.StartingPosition = point
//        on = false
//        theScene = scene.init(fileNamed: "\(scene)")
//        self.view?.presentScene(theScene, transition: .fade(withDuration: 0.2))
//    }
//}
extension SpeakerEnum {

    static func goto(_ string: [String],_ scene: Scene, startingPos: CGPoint? = nil) -> SpeakerEnum {
    
        return .questionaire(string, [
            ("Yes.", .runSelf({
                ($0.scene as? RootScene)?.present(scene)
                return .none
            })),
            ("No.", .none),
        ])
    
    }

}

enum SuperCharacters: Hashable {
    
    case base(Characters)
    case from(Characters, Int)
    
    var rawValue: String {
        switch self {
        case .base(let c):
            return c.rawValue
        case .from(let c, let i):
            return c.rawValue + " \(i)"
        }
    }
    
    var characterString: String {
        switch self {
        case .base(let c):
            return c.rawValue
        case .from(let c, _):
            return c.rawValue
        }
    }
    
    init(rawValue: String) {
        if let wo = Characters.init(rawValue: rawValue) {
            self = .base(wo)
        } else {
            let foo = rawValue.split(separator: " ")
            guard let ooflat = foo.last, let oofla = Int(String(ooflat)) else { fatalError() }
            let wowowo = foo.last?.count ?? 0
            var hm = rawValue
            hm.removeLast(wowowo + 1)
            self = .from(Characters.init(rawValue: hm)!, oofla)
        }
    }
}

