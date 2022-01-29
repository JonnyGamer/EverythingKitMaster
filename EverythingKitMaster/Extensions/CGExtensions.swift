//
//  CGExtensions.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import Foundation

public extension CGPoint {
    static var midScreen: Self { .init(x: w/2, y: h/2) }
    
    var half: CGPoint {
        return CGPoint(x: x/2, y: y/2)
    }
    func times(_ n: CGFloat) -> Self {
        return CGPoint(x: x*n, y: y*n)
    }
}
public extension CGSize {
    static var thousand: Self { .init(width: 1000, height: 1000) }
    static var screenSize: Self { .init(width: w, height: h) }
    func times(_ this: CGFloat) -> Self {
        return .init(width: width * this, height: height * this)
    }
    
    static var veryBig: Self {
        return Self.init(width: w*10, height: h*10)
    }
    static var hundred: Self {
        return Self.init(width: 100, height: 100)
    }
    func widen(times: CGFloat) -> Self {
        return Self.init(width: width * times, height: height)
    }
    func heighten(times: CGFloat) -> Self {
        return Self.init(width: width, height: height * times)
    }
}

public extension CGRect {
    static var screen: Self {
        return Self.init(origin: .zero, size: .screenSize)
    }
}

func pointOnACircle(angle: Double) -> CGVector {
    return CGVector(dx: cos((angle * .pi) / 180), dy: sin((angle * .pi) / 180))
}
