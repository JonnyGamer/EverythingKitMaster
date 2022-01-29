//
//  GameControllerScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/28/22.
//

import Foundation

var usedMouse = false

public enum _Keys: UInt16 { case spacebar = 49, leftArrow = 123, rightArrow = 124, upArrow = 126, downArrow = 125, back = 51, a = 0, s = 1, d = 2 }

public extension RootScene {
    
    func keyPressed(key: _Keys, hardness: CGFloat) {
        if !usedMouse {
            //theJoyStick.fadeOut()
            //theJoyPad.fadeOut()
        }
        
        if key == .rightArrow || key == .leftArrow {
            keysDown.insert(key)
            hardnessX = hardness
        }
        if key == .downArrow || key == .upArrow {
            keysDown.insert(key)
            hardnessY = hardness
        }
        
        if key == .upArrow {
            currentScene._onKeyDown(.up)
        }
        if key == .downArrow {
            currentScene._onKeyDown(.down)
        }
        
        if key == .a {
            pressedA()
        }
        
        if key == .s {
            //GameCenterHelper.openLeaderboard(.numberOfBaskets)
            //GameCenterHelper.openAchievement(.purchaseBasket)
            //GameCenterHelper.helper.presentMatchmaker()
        }
        if key == .d {
            GameCenterHelper.openGameCenter()
        }
        
    }
    func keyReleased(key: _Keys) {
        if key == .rightArrow || key == .leftArrow {
            keysDown.remove(key)
            hardnessX = nil
        }
        if key == .downArrow || key == .upArrow {
            keysDown.remove(key)
            hardnessY = nil
        }
        if key == .a {
            stoppedPressingA()
        }
        keysDown.remove(key)
    }
}
