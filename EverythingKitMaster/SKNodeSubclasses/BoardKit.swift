//
//  BoardKit.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

@objc public protocol Tilable {
    var x: Int { get set }
    var y: Int { get set }
    var position: CGPoint { get set }
    static func Make(color: NSColor, size: CGSize) -> Self
    //init(color: NSColor, size: CGSize)
}
extension Tilable {
}

open class Tile: SKSpriteNode, Tilable {
    public var x = 0
    public var y = 0
    public static func Make(color: NSColor, size: CGSize) -> Self {
        return self.init(color: color, size: size)
    }
}
open class RoundTile: SKShapeNode, Tilable {
    public var x = 0
    public var y = 0
    public static func Make(color: NSColor, size: CGSize) -> Self {
        return self.init(rectOf: size, cornerRadius: size.width/4).then {
            $0.fillColor = color
            $0.strokeColor = .clear
        }
    }
}


open class Board<T: Tilable>: SKNode {
    
    deinit {
        print("Bye Bye 2")
    }
    
    public var dimensions: (x: Int, y: Int)
    public var array: [[T]] = []
    
    public func tile(x: Int, y: Int) -> T {
        return array[x-1][y-1]
    }
    
    public func neighbors(x: Int, y: Int) -> [T] {
        var n: [T] = []
        for dx in [-1,0,1] {
            for dy in [-1,0,1] {
                if dx == 0, dy == 0 { continue }
                let newX = x + dx
                let newY = y + dy
                if newX < 1 || newX > dimensions.x { continue }
                if newY < 1 || newY > dimensions.y { continue }
                n.append(tile(x: newX, y: newY))
            }
        }
        return n
    }
    
    public init(x: Int, y: Int, padding: CGFloat = 0) {
        self.dimensions = (x, y)
        super.init()
        
        for x in 1...x {
            array.append([])
            for y in 1...y {
                let tile = T.Make(color: .black, size: .hundred)
                let padded = (padding * 100) + 100
                tile.position = CGPoint(x: CGFloat(x) * padded, y: CGFloat(y) * padded)
                array[x-1].append(tile)
                tile.x = x
                tile.y = y
                addChild(tile as! SKNode)
            }
        }
    }
    
    public func loop(_ run: (T) -> ()) {
        for x in 1...dimensions.x {
            for y in 1...dimensions.y {
                run(tile(x: x, y: y))
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#if os(macOS)
extension SKScene {
    open override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodos = nodes(at: location)
        for i in nodos {
            if let j = i as? Tilable {
                tapped(tile: j)
            }
        }
    }
}
#endif

#if os(iOS)
public extension SKScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let nodos = nodes(at: location)
        for i in nodos {
            if let j = i as? Tilable {
                tapped(tile: j)
            }
        }
    }
}
#endif


extension SKScene {
    @objc open func tapped(tile: Tilable) {}
}
