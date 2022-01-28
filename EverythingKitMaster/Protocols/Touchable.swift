//
//  Touchable.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

extension Array where Element == SKNode {
    public func touchBegan() {
        for i in self {
            if let io = i as? SuperTouchable {
                io._touchBegan()
            }
        }
    }
    public func touchEndedOn() {
        for i in self {
            if let io = i as? SuperTouchable {
                io._touchEndedOn()
            }
        }
    }
    public func touchReleased() {
        for i in self {
            if let io = i as? SuperTouchable {
                io._touchReleased()
            }
        }
    }
}

@objc public protocol SuperTouchable {
    func _touchBegan()
    func _touchReleased()
    func _touchEndedOn()
    var touchBegan: (Self) -> () { get set }
    var touchReleased: (Self) -> () { get set }
    var touchEndedOn: (Self) -> () { get set }
}

