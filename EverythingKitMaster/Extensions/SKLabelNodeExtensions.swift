//
//  SKLabelNodeExtensions.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

public extension SKLabelNode {
    func bold() {
        fontName = "Avenir Next"
    }
    func unpixelate() {
        fontSize *= xScale
        setScale(1.0)
    }
    
    func basicText(keepInside: CGSize) {
        self.bold()
        self.keepInside(keepInside)
        self.unpixelate()
        self.centerAt(point: .zero)
        self.fontColor = .black
    }
    
}
