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

enum SuperCharacters: Hashable {
    
    case base(Characters)
    case from(Characters, Int)
    
//    var nameAndPosition: (String, Int, Int) {
//        switch self {
//        case .base(let c, let d, let e):
//            return (c.rawValue, d, e)
//        }
//    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .base(let c):
            hasher.combine(c)
        case .from(let c, let d):
            hasher.combine(c)
            hasher.combine(d)
        }
    }
    
}

