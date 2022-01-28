//
//  Base.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

public var w: CGFloat = 1000
public var h: CGFloat = 1000
var root: RootScene!

public func correctSize(_ view: SKView) -> CGSize {
    w = (view.frame.width / view.frame.height) * 1000
    #if os(macOS)
    if let screenSize = NSScreen.main?.frame.size {
        w = (screenSize.width / screenSize.height) * 1000
    }
    #endif

    return .screenSize
}

public func build(_ view: SKView,_ startingScene: Scene) {
    let scene = RootScene.init(size: correctSize(view), startingScene: startingScene)
    root = scene
    scene.scaleMode = .aspectFit
    view.presentScene(scene)
    
    view.preferredFramesPerSecond = 120
    view.ignoresSiblingOrder = true
    
    view.showsFPS = false
    view.showsNodeCount = false
}

#if os(iOS)
public typealias NSColor = UIColor
#endif
