//
//  SKNodeExtensions.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

public extension SKNode {
    func centerAt(point: CGPoint) {
        position = point
        let whereThis = calculateAccumulatedFrame()
        position.x += point.x - whereThis.midX
        position.y += point.y - whereThis.midY
    }

    func keepInside(_ thhisSize: CGSize) {
        let nodeSize = calculateAccumulatedFrame()
        setScale(min((thhisSize.width / nodeSize.width) * xScale, (thhisSize.height / nodeSize.height) * yScale))
    }
}


public enum Constraints {
    case top, bottom, left, right
}


public extension SKNode {
    func centerAt(x: CGFloat) {
        position.x = x
        let whereThis = calculateAccumulatedFrame()
        position.x += x - whereThis.midX
    }
    func centerAt(y: CGFloat) {
        position.y = y
        let whereThis = calculateAccumulatedFrame()
        position.y += y - whereThis.midY
    }
    func place(_ constraint: Constraints, on: CGRect, _ con2: Constraints) {
        switch con2 {
        case .top: self.centerAt(y: on.maxY)
        case .bottom: self.centerAt(y: on.minY)
        case .right: self.centerAt(x: on.maxX)
        case .left: self.centerAt(x: on.minX)
        }
        switch constraint {
        case .top: self.position.y -= calculateAccumulatedFrame().size.height / 2
        case .bottom: self.position.y += calculateAccumulatedFrame().size.height / 2
        case .right: self.position.x -= calculateAccumulatedFrame().size.width / 2
        case .left: self.position.x += calculateAccumulatedFrame().size.width / 2
        }
    }
    func place(_ constraint: Constraints, on: SKNode, _ con2: Constraints) {
        self.place(constraint, on: on.calculateAccumulatedFrame(), con2)
    }
}

public extension SKNode {
    func padding(times: CGFloat = 1.1) -> SKNode {
        let padd = SKSpriteNode.init(color: .clear, size: self.calculateAccumulatedFrame().size.times(times))
        padd.position = self.position
        self.parent?.addChild(padd)
        self.move(toParent: padd)
        return padd
    }
}

public extension SKNode {
    func fadeIn() {
        alpha = 0
        run(.fadeIn(withDuration: 0.1))
    }
    func fadeOut() {
        run(.fadeOut(withDuration: 0.1))
    }
    
    func fadeOutGoodBye() {
        run(.fadeOut(withDuration: 0.1)) {
            self.removeFromParent()
        }
    }
}
