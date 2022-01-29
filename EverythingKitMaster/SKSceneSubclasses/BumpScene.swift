//
//  BumpScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/28/22.
//

import SpriteKit

extension SpeakerScene {

//    func didMove() {
//        character.setScale(0.5)
//        print("Yeet")
//        for i in childNode(withName: "Walls")?.children ?? [] {
//            if let io = i as? KeepYouInside {
//                io.level = (i.userData?["level"] as? Int) ?? 0
//                insideBlocks.append(io)
//                io.alpha = 0.1
//            }
//        }
//        for i in childNode(withName: "Walls2")?.children ?? [] {
//            if let io = i as? KeepYouInside {
//                io.level = (i.userData?["level"] as? Int) ?? 0
//                outsideBlocks.append(io)
//                io.alpha = 0
//            }
//        }
//
//        for i in children {
//            if i.name == "Paths" {
//                i.zPosition = -.infinity
//                continue
//            }
//
//            i.zPosition = -i.frame.minY
//            for j in i.children {
//                j.zPosition = -j.frame.minY
//                for k in j.children {
//                    if let io = k as? KeepYouInside {
//                        k.move(toParent: self as! SKNode)
//                        io.level = (i.userData?["level"] as? Int) ?? 0
//                        outsideBlocks.append(io)
//                        io.alpha = 0
//                    } else if let io = k as? Speak {
//                        k.move(toParent: self as! SKNode)
//                    } else {
//                        k.zPosition = -.infinity
//                    }
//
//                    if (k.userData?["standing"] as? Bool) == true {
//                        k.zPosition += 2000
//                    }
//                }
//
//                if let increase = (j.userData?["standing"] as? Int) {
//                    j.zPosition += CGFloat(increase)
//                }
//            }
//        }
//
//        addChild(character)
//
//        //joyStick()
//    }
        
}
