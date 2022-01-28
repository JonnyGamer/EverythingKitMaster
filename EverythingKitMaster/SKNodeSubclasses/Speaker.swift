//
//  Speaker.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

import SpriteKit
import GameKit

class Selectable: SKShapeNode {
    //var text: String?
    static func Make(_ text: String) -> Selectable {
        let this = Selectable.init(rectOf: .init(width: 200, height: 25), cornerRadius: 12.5)
        let newText = SKLabelNode.init(text: text)
        this.addChild(newText)
        //this.text = text
        newText.fontName = "Avenir"
        newText.fontColor = .black
        newText.horizontalAlignmentMode = .left
        newText.position.y -= 5
        newText.position.x -= 85
        //text.verticalAlignmentMode = .center
        newText.setScale(0.5)
        if newText.frame.width > 200*0.8 {
            newText.setScale(0.5*(200*0.8)/newText.frame.width)
        }
        newText.zPosition = 100000
        this.fadeIn()
        
        return this
    }
}

public class Speak: SKSpriteNode {
    var speech: SpeakerEnum = .message(["..."])
    
    var personSpeaking: SKSpriteNode?
    var speakingArray: [SpeakerEnum]?
    var text: SKLabelNode?
    
    var selectedQuestionaire: [Selectable] = []
    var selectedOne: Int = 0
    var selectedAnswer: Int?
    
    var currentlySpeaking: String!
    var originalPersonSpeaking: SKSpriteNode!
    var originalSpeaker: String!
    
}

enum SpeakerEnum {
    case none
    case message([String])
    case longMessage([Self])
    case questionaire([String], [(String, Self)])
    case run(() -> Self)
    case runSelf((Speak) -> Self)
    case quickRunSelf((Speak) -> ())
    case exec(() -> ())
    case achieve(Achievements)
    indirect case ifStatement(() -> Bool, Self)
    //case goto(Scene)
    
    case leaderBoard(Leaderboards, (Int) -> Int)
    case leaderBoardWithContext(Leaderboards, Contexts, (Int) -> Int)
    case yourLeaderboardSpot(Leaderboards, (GKLeaderboard.Entry, Int) -> Self)
    case getLeaderboard(Leaderboards, GameCenter.GetLeaderboard, (GKLeaderboard.Entry, [GKLeaderboard.Entry], Int) -> Self)
    
    indirect case whileLoop(() -> Bool, Self)
    indirect case repeatTimes(() -> Int, Self)
    
    indirect case nudge(String, Self)
    
    func buildSpeechArray() -> [SpeakerEnum] {
        switch self {
        
        case .repeatTimes(let times, let foo):
            let t = times()
            if times() < 0 { return [] }
            var combo: [Self] = []
            for i in 0..<t {
                combo += foo.buildSpeechArray()
            }
            return combo
        
        case .whileLoop(let checkif, let foo):
            if checkif() {
                return foo.buildSpeechArray() + [self]
            } else {
                return []
            }
            
        case .ifStatement(let checkIf, let foo):
            if checkIf() {
                return foo.buildSpeechArray()
            } else {
                return []
            }
            
        case .achieve(let ach): return [.exec({ GameCenter.achieve(ach) })]
        
        case .leaderBoard(let ach, let dor): return [.exec({ GameCenter.modifyHighscore(ach, willDo: dor) })]
        case .leaderBoardWithContext(let ach, let con, let dor): return [.exec({ GameCenter.modifyHighscore(ach, context: con, willDo: dor) })]
        
        case .yourLeaderboardSpot(let led, let willRun):
            return [
                .run({
                    let wow = GameCenter.getLeaderboard(led, with: .getScores(.global, .allTime, .topScore))
                    if let you = wow.0, wow.0?.rank != 0 {
                        return willRun(you, wow.totalNumberOfPlayers)
                    } else {
                        return .message(["(GameCenter is not connected?)"])
                    }
                })
            ]
        
        case .getLeaderboard(let led, let get, let willRun):
            return [
                .run({
                    let wow = GameCenter.getLeaderboard(led, with: get)
                    if let you = wow.0, !wow.1.isEmpty {
                        return willRun(you, wow.1, wow.totalNumberOfPlayers)
                    } else {
                        return .message(["(GameCenter is not connected?)"])
                    }
                })
            ]
            
            
        case .none: return []
        case .message: return [self]
        case .longMessage(let foo): return foo.reduce(into: []) { $0 += $1.buildSpeechArray() }
        case .questionaire: return [self]
        case .run: return [self]
        case .runSelf: return [self]
        case .quickRunSelf: return [self]
        case .exec: return [self]
        case .nudge(let person, let messages):
            var willResetTo = ""
            return [
            .runSelf({ i in
                willResetTo = i.currentlySpeaking
                i.newSpeaker(to: person)
                return messages
            }),
            .quickRunSelf({ i in
                i.newSpeaker(to: willResetTo)
            })
        ]
        //case .nudge(_, let foo): return foo.buildSpeechArray()// [self]
        }
    }
}

extension Speak {
    
    func selectOption() {
        selectedAnswer = selectedOne
    }
    func select(up: Bool?) {
        if !selectedQuestionaire.isEmpty {
            //selectedQuestionaire[selectedOne].strokeColor = .black
            //selectedQuestionaire[selectedOne].setScale(1.0)
            if let up = up {
                selectedOne += up ? (selectedQuestionaire.count-1) : 1
                selectedOne = selectedOne % selectedQuestionaire.count
            }
            
            for i in 0..<selectedQuestionaire.count {
                if i == selectedOne {
                    selectedQuestionaire[i].fillColor = .white
                    selectedQuestionaire[i].strokeColor = .red
                    selectedQuestionaire[i].setScale(1.1)
                } else {
                    selectedQuestionaire[i].fillColor = .init(white: 0.9, alpha: 1.0)
                    selectedQuestionaire[i].strokeColor = .black
                    selectedQuestionaire[i].setScale(1.0)
                }
            }
        }
    }
    
    func setSpeaker(to: SKSpriteNode) {
        currentlySpeaking = to.name
        personSpeaking = to
        originalPersonSpeaking = to
        originalSpeaker = to.name
    }
    func newSpeaker(to: String) {
        currentlySpeaking = to
        //personSpeaking?.removeFromParent()
        personSpeaking = SKSpriteNode.init(imageNamed: to)
        personSpeaking?.name = to
//        let wo = personSpeaking!
//        let foo = self
//        wo.name = to
//        wo.setScale(min(70 / wo.size.height, 70 / wo.size.width))
//        wo.position.x = -foo.frame.size.width/2
//        wo.position.x += 25 + (wo.size.width/2)
//        wo.position.y = -foo.frame.size.height/2
//        wo.position.y += wo.size.height/2
//        wo.position.y += (foo.frame.size.height - wo.size.height)/2
//        addChild(wo)
    }
    func reset() {
        currentlySpeaking = originalSpeaker
        personSpeaking = originalPersonSpeaking
    }
    
    func resolveSpeech(textBubble: SKShapeNode) -> Bool {
        
        do {
            let t = text
            
            if Thread.current.isMainThread {
                t?.move(toParent: textBubble.parent!)
            } else {
                DispatchQueue.main.sync {
                    t?.move(toParent: textBubble.parent!)
                }
            }
            
            
            t?.fadeOutGoodBye()
            text = nil
            selectedOne = 0
            for i in selectedQuestionaire {
                i.fadeOutGoodBye()
            }
            selectedQuestionaire = []
            selectedAnswer = nil
            //if selectedAnswer != nil {
            //    return false
            //}
        }
        
        if speakingArray == nil {
            speakingArray = speech.buildSpeechArray()
        } else if speakingArray!.isEmpty {
            print("* Done With Speech *")
            speakingArray = nil
            return true
        }
        
        if originalSpeaker != currentlySpeaking, let removeMe = textBubble.childNode(withName: originalSpeaker) {
            removeMe.removeFromParent()
            
            let foo = textBubble
            let wo = SKSpriteNode.init(imageNamed: currentlySpeaking)
            foo.addChild(wo)
            foo.zPosition = .infinity
            wo.setScale(min(70 / wo.size.height, 70 / wo.size.width))
            wo.position.x = -foo.frame.size.width/2
            wo.position.x += 25 + (wo.size.width/2)
            wo.position.y = -foo.frame.size.height/2
            wo.position.y += wo.size.height/2
            wo.position.y += (foo.frame.size.height - wo.size.height)/2
        }
        
        //print(textBubble.childNode(withName: originalSpeaker))
        //print(textBubble.children.count, "-")
        
        let currentSpeech = speakingArray!.removeFirst()
        switch currentSpeech {
            
        case .message(let foo):
            
            DispatchQueue.main.sync {
                
                print(foo)
                text = SKLabelNode.init(text: foo.convertedToString)
                if let text = text {
                    textBubble.addChild(text)
                    text.fontName = "Avenir"
                    text.fontColor = .black
                    text.horizontalAlignmentMode = .left
                    //text.verticalAlignmentMode = .center
                    text.setScale(1.0)
                    text.zPosition = 100000
                    text.position.x = (-textBubble.frame.width/2) + 80 + 25 + 25
                    text.position.y -= CGFloat(foo.count - 1) * 45
                    text.fadeIn()
                    if #available(iOS 11.0, *) {
                        text.numberOfLines = foo.count
                    } else {
                        // Fallback on earlier versions
                    }
                    if text.frame.width > 700*0.75 {
                        text.setScale((700*0.75)/text.frame.width)
                    }
                }
                
                if let wo = textBubble.children.first {
                    wo.removeAllActions()
                    //let ow = wo.name!
                    wo.run((scene as? SpeakerScene)?.talkingAnimation(SuperCharacters(rawValue: currentlySpeaking).characterString, talkingOver: foo.convertedToString) ?? SKAction.run {
                        print("Broken")
                    })
                }
                
            }
            
            
        
        case .whileLoop:
            speakingArray = currentSpeech.buildSpeechArray() + (speakingArray ?? [])
            return resolveSpeech(textBubble: textBubble)
            
        case .run(let foo):
            speakingArray = foo().buildSpeechArray() + (speakingArray ?? [])
            return resolveSpeech(textBubble: textBubble)
        case .runSelf(let foo):
            speakingArray = foo(self).buildSpeechArray() + (speakingArray ?? [])
            return resolveSpeech(textBubble: textBubble)
        case .quickRunSelf(let foo):
            foo(self)
            return resolveSpeech(textBubble: textBubble)
        case .exec(let foo):
            foo()
            return resolveSpeech(textBubble: textBubble)
            
        case .questionaire(let question, let answers):
            print(question)
            
            let answerPossibilities: [String] = answers.map {
                print(" - ", $0.0)
                return $0.0
            }
            
            text = SKLabelNode.init(text: question.convertedToString)
            if let text = text {
                textBubble.addChild(text)
                text.fontName = "Avenir"
                text.fontColor = .black
                text.horizontalAlignmentMode = .left
                //text.verticalAlignmentMode = .center
                text.setScale(1.0)
                text.zPosition = 100000
                text.position.x = (-textBubble.frame.width/2) + 80 + 25 + 25
                text.position.y -= CGFloat(question.count - 1) * 45
                text.fadeIn()
                if #available(iOS 11.0, *) {
                    text.numberOfLines = question.count
                } else {
                    // Fallback on earlier versions
                }
                if text.frame.width > 700*0.75 {
                    text.setScale((700*0.75)/text.frame.width)
                }
                
                if let textParent = text.parent {
                    var superMinY = CGFloat(-75)
                    let superMaxX = textParent.frame.maxX - 125
                    for i in answerPossibilities {
                        let foo = Selectable.Make(i)// SKShapeNode.init(rectOf: .init(width: 200, height: 25), cornerRadius: 12.5)
                        foo.fillColor = .white
                        foo.strokeColor = .black
                        foo.lineWidth = 2
                        text.addChild(foo)
                        
                        if Thread.current.isMainThread {
                            foo.move(toParent: textParent)
                        } else {
                            DispatchQueue.main.sync {
                                foo.move(toParent: textParent)
                            }
                        }
                        
                        
                        foo.position.x = superMaxX
                        foo.position.y = superMinY
                        superMinY -= 35
                        selectedQuestionaire.append(foo)
                    }
                }
                
                selectedOne = 0
                select(up: nil)
                
                if let wo = textBubble.children.first {
                    wo.removeAllActions()
                    wo.run((scene as? SpeakerScene)!.talkingAnimation(SuperCharacters(rawValue: currentlySpeaking).characterString, talkingOver: question.convertedToString))
                }
                
            }
            
            let userResponse = awaitingAnswers(answerPossibilities)

            guard let (_, whatComesNext) = answers.first(where: { $0.0 == userResponse }) else { fatalError() }

            speakingArray = whatComesNext.buildSpeechArray() + (speakingArray ?? [])
            return resolveSpeech(textBubble: textBubble)
            
        case .longMessage: fatalError()
        case .nudge: fatalError()
        case .none: fatalError()
        case .achieve: fatalError()
            
        case .leaderBoard: fatalError()
        case .leaderBoardWithContext: fatalError()
        case .getLeaderboard: fatalError()
        case .yourLeaderboardSpot: fatalError()
        case .ifStatement: fatalError()
            
            //return resolveSpeech(textBubble: textBubble)
        case .repeatTimes: fatalError()
        
        }
        
        return false
        
    }
    
    
    func awaitingAnswers(_ with: [String]) -> String {
        while true {
            if let a = selectedAnswer {
                return with[a]
            }
        }
    }
//    func awaitingAnswers(_ with: [String]) -> String {
//        while true {
//            let userAnswer = pleaseReadLine()
//            if with.contains(userAnswer) {
//                return userAnswer
//            } else {
//                print("* invalid response *")
//            }
//        }
//    }
//    func pleaseReadLine() -> String {
//        while true {
//            if let f = readLine() {
//                return f
//            }
//        }
//    }
    
}

