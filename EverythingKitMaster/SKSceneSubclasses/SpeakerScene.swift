//
//  SpeakerScene.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit

public class KeepYouInside: SKSpriteNode {
    var level: Int = 0
}
public class Character: SKSpriteNode {
    //var insideOf: KeepYouInside!
    var currentLevel: Int = 1
}
public class Speak: SKSpriteNode {
    var speech: Communication = .message(["..."])
    var char: SuperCharacters = .base(.door)
}


class SpeakerScene: Scene {
    
    static var StartPosition: CGPoint?
    var character: Character = Character.init(imageNamed: "Inky")
    var insideBlocks: [KeepYouInside] = []
    var outsideBlocks: [KeepYouInside] = []
    var speakBlocks: [Speak] = []
    var canSpeakWith: Speak?
    
    var standingTexture: SKTexture = SKTexture(imageNamed: "Inky")
    var walkingAction: SKAction = SKAction.animate(with: [
        SKTexture.init(imageNamed: "InkyWalk1"),
        SKTexture.init(imageNamed: "InkyWalk2"),
        SKTexture.init(imageNamed: "InkyWalk3"),
    ], timePerFrame: 0.1)
    
    var backgroundMusic: MusicType = MusicList.theIndustry
    var peopleToSpeakWith: [SuperCharacters : Communication] { [:] }
    var world: SKNode = SKNode()
    

    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(_ screenSize: CGSize = CGSize.init(width: w, height: h)) {
        super.init(screenSize)
    }
    
    public override func began() {
        background.color = .white
        setupScene(self, startPosition: (34, 23))
    }
    
    public override func touchBegan() {
        
        if root.theJoyPad == nil {
            root.joyStick()
        }
        
    }
    
    func talkingAnimation(_ person: String, talkingOver: String) -> SKAction {
        print(person)
        guard let character = Characters.init(rawValue: person) else { fatalError() }
        let animation = character.animation()
        return .speakingAnimation(words: talkingOver, sound: character.sound(over: talkingOver), anim1: animation.0, anim2: animation.1)
    }
    
    func setupScene(_ scene: Scene, startPosition: (Int, Int)) {
        Music.o.playMusic(backgroundMusic.rawValue)
        let startPosition: CGPoint = Self.StartPosition ?? .init(x: startPosition.0, y: startPosition.1)
        Self.StartPosition = nil
        
        do {
            // Lets you know which room you in
            let wow = SKLabelNode.init(text: "\(type(of: scene))")
            wow.bold()
            wow.fontColor = .black
            addChild(wow)
            wow.place(.bottom, on: .screen, .bottom)
            wow.centerAt(x: w/2)
            wow.position.y += 20
            wow.keepInside(.hundred)
            wow.unpixelate()
            wow.zPosition += 10
        }
        
        
        scene.addChild(world)
        
        let wow = SKScene.init(fileNamed: "\(type(of: scene))")
        for i in wow?.children ?? [] {
            i.move(toParent: world)
        }
        
        for i in world.childNode(withName: "Walls")?.children ?? [] {
            if let io = i as? KeepYouInside {
                io.level = (i.userData?["level"] as? Int) ?? 0
                insideBlocks.append(io)
                io.alpha = 0.1
            }
        }
        for i in world.childNode(withName: "Walls2")?.children ?? [] {
            if let io = i as? KeepYouInside {
                io.level = (i.userData?["level"] as? Int) ?? 0
                outsideBlocks.append(io)
                io.alpha = 0
            }
        }
        
        for i in world.children {
            if i.name == "Paths" {
                i.zPosition = -.infinity
                continue
            }
            
            i.zPosition = -i.frame.minY
            for j in i.children {
                j.zPosition = -j.frame.minY
                for k in j.children {
                    if let io = k as? KeepYouInside {
                        k.move(toParent: self)
                        io.level = (i.userData?["level"] as? Int) ?? 0
                        outsideBlocks.append(io)
                        io.alpha = 0
                    } else if let io = k as? Speak {
                        //io.level = (i.userData?["level"] as? Int) ?? 0
                        speakBlocks.append(io)
                        
                        if let n = io.parent?.name?.split(separator: " ") {
                            if n.count == 1 {
                                io.char = .base(.init(rawValue: String(n[0]))!)
                            } else if n.count == 2 {
                                io.char = .from((.init(rawValue: String(n[0]))!), Int(n[1])!)
                            }
                        }
                        
                        k.move(toParent: self)
                        io.alpha = 0
                        //io.personSpeaking = j as? SKSpriteNode
                        //io.setSpeaker(to: j as! SKSpriteNode)
                    } else {
                        k.zPosition = -.infinity
                    }
                    
                    if (k.userData?["standing"] as? Bool) == true {
                        k.zPosition += 2000
                    }
                }
                
                if let increase = (j.userData?["standing"] as? Int) {
                    j.zPosition += CGFloat(increase)
                }
            }
        }
        
//        var fade = 0.1
//        for i in peopleToSpeakWith {
//            let (name, x, y) = i.key.nameAndPosition
//            let wo = Speak.init(imageNamed: name)
//            world.addChild(wo)
//            wo.speech = i.value
//            wo.position = .init(x: x, y: y)
//            wo.alpha = 0
//            wo.zPosition = -wo.frame.minY
//            wo.run(.sequence([
//                .wait(forDuration: fade),
//                .run { wo.fadeIn() }
//            ]))
//            fade += 0.1
//        }
        
        character.setScale(0.5)
        world.addChild(character)
        
        character.position = startPosition//.init(x: startPosition.x - (w/2), y: <#T##CGFloat#>)
        world.position = .init(x: -character.position.x + w/2, y: -character.position.y + h/2)
        
        //world.position = .midScreen
        //let cameraStart = Self.StartingPosition
        //world.position = cameraStart
        //character.position = cameraStart
        
    }
    
    
    override func update() {
        if chatBox != nil {
            if character.action(forKey: "foo") != nil {
                character.removeAction(forKey: "foo")
                character.texture = standingTexture
            }
            return
        }

        if !root.keysDown.isEmpty {
            let previousFrame = character.frame
            var dxdy = CGVector.zero
            for i in root.keysDown {
                switch i {
                case .leftArrow: character.position.x -= 10 * (root.hardnessX ?? 1.0); dxdy.dx -= 10 * (root.hardnessX ?? 1.0)
                case .upArrow: character.position.y += 10 * (root.hardnessY ?? 1.0); dxdy.dy += 10 * (root.hardnessY ?? 1.0)
                case .downArrow: character.position.y -= 10 * (root.hardnessY ?? 1.0); dxdy.dy -= 10 * (root.hardnessY ?? 1.0)
                case .rightArrow: character.position.x += 10 * (root.hardnessX ?? 1.0); dxdy.dx += 10 * (root.hardnessX ?? 1.0)
                default: continue
                }
            }
            movedSomething(character, previousFrame: previousFrame, dxdy: CGVector.init(dx: dxdy.dx, dy: 0.0))
            movedSomething(character, previousFrame: previousFrame, dxdy: CGVector.init(dx: 0.0, dy: dxdy.dy))

            if dxdy.dx > 0 {
                character.xScale = 0.5
            }
            if dxdy.dx < 0 {
                character.xScale = -0.5
            }

            character.zPosition = -character.frame.minY

            if dxdy != .zero {
                if character.action(forKey: "foo") == nil {
                    character.run(.repeatForever(walkingAction), withKey: "foo")
                }
                character.speed = max(root.hardnessX ?? 1, root.hardnessY ?? 1) // slow down the walking speed
            } else {
                if character.action(forKey: "foo") != nil {
                    character.removeAction(forKey: "foo")
                    character.texture = standingTexture
                }
            }

        } else {

            if character.action(forKey: "foo") != nil {
                character.removeAction(forKey: "foo")
                character.texture = standingTexture
            }

        }

    }
    
    
    
    func movedSomething(_ this: SKSpriteNode, previousFrame: CGRect, dxdy: CGVector) {
        if dxdy == .zero { return }
        
        let wo = this.frame
        
        let uwu = [
            (CGPoint.init(x: previousFrame.midX, y: previousFrame.midY), CGPoint.init(x: wo.midX, y: wo.midY), true, true),
        ]
        
        
        // Outside blocks
        for i in uwu {
            let previousBottomLeftPos = i.0
            let bottomLeftPos = i.1
            let blocksBottomLeftWillBeIn = outsideBlocks.filter { $0.frame.contains(bottomLeftPos) }
            
            if !blocksBottomLeftWillBeIn.isEmpty {
                for i in blocksBottomLeftWillBeIn {
                    keepOutsideThis(this: this, inside: i.frame, dxdy: dxdy)
                }
            }
        }
        
        // Inside Blocks
        for i in uwu {
            let previousBottomLeftPos = i.0
            let bottomLeftPos = i.1
            var previousBlocksBottomLeftWasIn = insideBlocks.filter { $0.frame.contains(previousBottomLeftPos) }
            previousBlocksBottomLeftWasIn = previousBlocksBottomLeftWasIn.filter({ $0.level == character.currentLevel || $0.level + 1 == character.currentLevel || $0.level - 1 == character.currentLevel })
            
            var blocksBottomLeftWillBeIn = insideBlocks.filter { $0.frame.contains(bottomLeftPos) }
            //let level = previousBlocksBottomLeftWasIn[0].level
            blocksBottomLeftWillBeIn = blocksBottomLeftWillBeIn.filter({ $0.level == character.currentLevel || $0.level + 1 == character.currentLevel || $0.level - 1 == character.currentLevel })
            //print("-")
            //print(newBoxes.map { $0.level })
            
            if !previousBlocksBottomLeftWasIn.isEmpty {
                character.currentLevel = previousBlocksBottomLeftWasIn[0].level
                //print(character.currentLevel)
                
                if blocksBottomLeftWillBeIn.isEmpty {
                    
                    // If you didn't find a new square to enter....
                    // Keep inside whatever it is you were in before
                    keepInsisdeThis(this: this, inside: previousBlocksBottomLeftWasIn.reduce(previousBlocksBottomLeftWasIn[0].frame) { $0.union($1.frame) }, minX: i.2, minY: i.3)
                    
                } else {
                    assert(!previousBlocksBottomLeftWasIn.isEmpty)
                    //assert(previousBlocksBottomLeftWasIn.count == 1)
                    //assert(blocksBottomLeftWillBeIn.count == 1)
                    
                    // Create a set of all the new boxes you could be in
                    var newBoxes = Set(blocksBottomLeftWillBeIn).subtracting(previousBlocksBottomLeftWasIn)
                    
                    if newBoxes.isEmpty {
                        
                        // Keep you inside what you are currently in
                        keepInsisdeThis(this: this, inside: blocksBottomLeftWillBeIn.reduce(previousBlocksBottomLeftWasIn[0].frame) { $0.union($1.frame) }, minX: i.2, minY: i.3)
                        
                    } else {
                        assert(newBoxes.count == 1)
                        let foo = newBoxes.first!.frame
                        let bar = previousBlocksBottomLeftWasIn[0].frame
                        
                        
                        if Int(foo.minY) == Int(bar.maxY) || Int(foo.maxY) == Int(bar.minY) || Int(foo.minX) == Int(bar.maxX) || Int(foo.maxX) == Int(bar.minX) {
                            // Get inside that new shape
                            keepInsisdeThis(this: this, inside: blocksBottomLeftWillBeIn.reduce(previousBlocksBottomLeftWasIn[0].frame) { $0.union($1.frame) }, minX: i.2, minY: i.3)
                        } else {
                            
                            // Stay inside the old shape
                            keepInsisdeThis(this: this, inside: previousBlocksBottomLeftWasIn.reduce(previousBlocksBottomLeftWasIn[0].frame) { $0.union($1.frame) }, minX: i.2, minY: i.3)
                        }
                    }
                }
            } else {
                //print("HOW!/ \(i.2), \(i.3)")
            }
        }
        
//        // SPEAK - this next
        for i in uwu {
            let previousBottomLeftPos = i.0
            let bottomLeftPos = i.1
            let blocksBottomLeftWillBeIn = speakBlocks.filter { $0.frame.contains(bottomLeftPos) }

            if !blocksBottomLeftWillBeIn.isEmpty {

                if canSpeakWith !== blocksBottomLeftWillBeIn.first {
                    print("CAN SPEAK")
                    canSpeakWith = blocksBottomLeftWillBeIn.first
                    for i in blocksBottomLeftWillBeIn {
                        //keepOutsideThis(this: this, inside: i.frame, dxdy: dxdy)
                    }
                    root.canPressA()
                }

            } else {
                canSpeakWith = nil
                root.cannotPressA()
            }
        }
        
        world.position = .init(x: -character.position.x + w/2, y: -character.position.y + h/2)
        print( " - Character Position", "(\(Int(character.position.x)), \(Int(character.position.y)))" )
    }
    
    
    func keepInsisdeThis(this: SKSpriteNode, inside: CGRect, minX: Bool, minY: Bool) {
        let wo = this.frame
            
        if wo.midX <= inside.minX {
            this.position.x = inside.minX + 0.01
        } else if wo.midX >= inside.maxX {
            this.position.x = inside.maxX - 0.01
        }
    
        
        if wo.midY <= inside.minY {
            this.position.y = inside.minY + 0.01
        } else if wo.midY >= inside.maxY {
            this.position.y = inside.maxY - 0.01
        }
    }
    func keepOutsideThis(this: SKSpriteNode, inside: CGRect, dxdy: CGVector) {
        let wo = this.frame
            
        if dxdy.dy != 0 {
            
            if dxdy.dy > 0, !(wo.midY - dxdy.dy > inside.minY) {
                if wo.midY > inside.minY {
                    //print(dxdy, inside.minY)
                    this.position.y = inside.minY - 0.01
                }
            } else if !(wo.midY - dxdy.dy < inside.maxY) {
                if wo.midY < inside.maxY {
                   this.position.y = inside.maxY + 0.01
               }
            }
            
        } else {
            
            if dxdy.dx > 0, !(wo.midX - dxdy.dx > inside.minX) {
                if wo.midX > inside.minX {
                    this.position.x = inside.minX - 0.01
                }
            } else if !(wo.midX - dxdy.dx < inside.maxX)  {
                if wo.midX < inside.maxX {
                    this.position.x = inside.maxX + 0.01
                }
            }

        }

    }


    
}
