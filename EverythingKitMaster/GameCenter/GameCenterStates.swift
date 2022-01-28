//
//  GameCenterStates.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/27/22.
//

// MARK: - LIST OF ACHIEVEMENTS AND LEADERBOARDS -

enum Achievements: String {
    case purchaseBasket = "PurchaseBasket"
}
enum Leaderboards: String {
    case numberOfBaskets = "NumberOfBasketsPurchased"
}
enum Contexts: Int {
    case mysteryContext = 1
}

// MARK: - Protocol Open Game Center Features -

protocol OpenGameCenter {
    // Open the game center dashboard
    static func openGameCenter()
    // Open a specific leaderboard
    static func openLeaderboard(_ board: Leaderboards)
    // Open your achievements
    static func openAchievement(_ achievement: Achievements)
}

protocol GameCenterable {
    // Use `GameCenter.achieve` to achieve something new! (I'll add percentage increase later)
    static func achieve(_ this: Achievements)
    // Achieve percentage increases!
    static func achieve(_ this: Achievements, percentageComplete: @escaping (Double) -> Double)
    // Use `GameCenter.setHighscore` to set a new highscore (it will never get less though, note for iOS 13 and less, you cannot do negative)
    static func setHighscore(number: Int, leaderboard: Leaderboards, context: Contexts?)
    // Use `GameCenter.modifyHighscore` to mutate it (i.e. $0 + 1) will add your current highscore by 1.
    static func modifyHighscore(_ this: Leaderboards, context: Contexts?, willDo: @escaping (Int) -> Int)
    
    
    //static func getAchievement(_ this: Achievements) -> GKAchievement
    static func getLeaderboard(_ this: Leaderboards, with: GameCenter.GetLeaderboard) -> (GKLeaderboard.Entry?, [GKLeaderboard.Entry], totalNumberOfPlayers: Int)
}


// MARK: - GAME CENTER HELPER CLASS -

import GameKit

final class GameCenterHelper: GKGameCenterViewController, GKGameCenterControllerDelegate, GKLocalPlayerListener {
        
    typealias CompletionBlock = (Error?) -> Void
    
    // 1
    static let helper = GameCenterHelper.init(nibName: "", bundle: nil)
    static var viewingDashboard = false
    
    // 2
    #if os(macOS)
    var viewController: NSViewController?
    #elseif os(iOS)
    var viewController: UIViewController?
    #endif
    
    var currentMatchmakerVC: GKMatchmakerViewController?
    
    func authenticateLocalPlayer() {
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
            if GKLocalPlayer.local.isAuthenticated {
                print("Authenticated to Game Center!")
                GKLocalPlayer.local.register(self)
            } else if let vc = gcAuthVC {
                #if os(macOS)
                self.viewController?.present(vc, animator: true as! NSViewControllerPresentationAnimator)
                #elseif os(iOS)
                self.viewController?.present(vc, animated: true)
                #endif
            } else {
                print("Error authentication to GameCenter: " + "\(error?.localizedDescription ?? "none")")
            }
        }
    }
    
    // Authenticate GameCenter: The Local Player
    #if os(macOS)
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        authenticateLocalPlayer()
    }
    #elseif os(iOS)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        authenticateLocalPlayer()
    }
    #endif
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

struct GameCenter: GameCenterable {
    

    // MARK: - LEADERBOARDS AND HIGHSCORES -
    
    // Set your highscore!
    static func setHighscore(number: Int, leaderboard: Leaderboards, context: Contexts? = nil) {
        if GKLocalPlayer.local.isAuthenticated {
            if #available(iOS 14.0, *, macOS 11.0, *) {
                // macOS 11.0, iOS 14.0 - NEW WAY TO DO Leaderboard
                GKLeaderboard.submitScore(number, context: context?.rawValue ?? 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboard.rawValue]){error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Score succesfully updated...")
                    }
                }
            } else {
                // OLD WAY TO DO Leaderboard
                // Unfortunately, you cannot store less than 0...
                let score = GKScore(leaderboardIdentifier: leaderboard.rawValue)
                score.value = Int64(number)
                score.context = UInt64(context?.rawValue ?? 0)
                GKScore.report([score], withCompletionHandler: { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                    } else {
                        print("Score succesfully updated...")
                    }
                })
            }
        }
    }
    
    static func getAchievement(_ this: Achievements) -> GKAchievement {
        fatalError()
    }
    
    enum GetLeaderboard {
        enum LeaderboardRange {
            case topScore
            case top10
            case top100
            case top(Int)
            case range(ClosedRange<Int>)
            func nsRange() -> NSRange {
                switch self {
                case .topScore: return NSRange(1...1)
                case .top10: return NSRange(1...10)
                case .top100: return NSRange(1...100)
                case .top(let n): return NSRange(1...n)
                case .range(let n): return NSRange(n)
                }
            }
        }
        
        case getScores(GKLeaderboard.PlayerScope, GKLeaderboard.TimeScope, LeaderboardRange)
        //case getYourself
    }
    
    static func getLeaderboard(_ this: Leaderboards, with: GameCenter.GetLeaderboard) -> (GKLeaderboard.Entry?, [GKLeaderboard.Entry], totalNumberOfPlayers: Int) {
        
        
        if #available(iOS 14.0, *, macOS 11.0, *) {
            
            switch with {
                
            case .getScores(let scope, let timeScope, let rangeRange):
                
                var numOfPlayers = 0
                var you: GKLeaderboard.Entry?
                var foundScores: [GKLeaderboard.Entry?]?
                
                let foo = DispatchQueue.init(label: "foo")
                
                foo.async {
                    
                    GKLeaderboard.loadLeaderboards(IDs: [this.rawValue]) { leaderboards, error in
                        if let leaderboard = leaderboards?.filter ({ $0.baseLeaderboardID == this.rawValue }).first {
                            
//                            leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...100)) { entry, entryReal, totalNumberOfPlayers, error  in
//                                numOfPlayers = totalNumberOfPlayers
//                                foundScores = entryReal ?? []
//                            }
                            
                            leaderboard.loadEntries(for: scope, timeScope: timeScope, range: rangeRange.nsRange()) { entry, entryReal, totalNumberOfPlayers, error  in
                                you = entry
                                numOfPlayers = totalNumberOfPlayers
                                foundScores = entryReal ?? []
                            }
                            
                            //while scores.count < Range(rangeRange.nsRange())!.count {}
                            //foundScores = scores
                            
                        }
                    }
                    
                }
                
                
                while foundScores == nil {}
                return (you, foundScores?.compactMap({ $0 }) ?? [], numOfPlayers)
            
            }
            
            
        }
        
        
        fatalError()
        
    }
    
    // Make a modification to your current score!
    static func modifyHighscore(_ this: Leaderboards, context: Contexts? = nil, willDo: @escaping (Int) -> Int) {
        
        if #available(iOS 14.0, *, macOS 11.0, *) {
            // macOS 11.0, iOS 14.0 - NEW WAY TO DO Leaderboard
            GKLeaderboard.loadLeaderboards(IDs: [this.rawValue]) { leaderboards, error in
                print("working ...")
                if let leaderboard = leaderboards?.filter ({ $0.baseLeaderboardID == this.rawValue }).first {
                    leaderboard.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime, completionHandler: { i, playersScores, k in
                        
                        var yourHighScore = 0
                        if let yourCurrentRank = playersScores?.first?.rank {
                            print("Is this your global rank?", yourCurrentRank)
                        }
                        if let yourCHighScore = playersScores?.first?.score {
                            yourHighScore = yourCHighScore
                            print("Is this your score?", yourCHighScore)
                        }
                        if let dateEarned = playersScores?.first?.date {
                            print("Date last earned?", dateEarned)
                        }
                        if let playerName = playersScores?.first?.player.displayName {
                            print("Is this your name...?", playerName)
                        }
                        
                        print("Change highscore from", yourHighScore, "to", willDo(yourHighScore))
                        setHighscore(number: willDo(yourHighScore), leaderboard: this, context: context)
                    })
                }
            }
            
        } else {
            // OLD WAY TO DO Leaderboard
            // Unfortunately, you cannot store less than 0...
            let localPlayer = GKLocalPlayer.local
            let board = GKLeaderboard(players: [localPlayer])
            board.identifier = this.rawValue
            board.loadScores { (playersScores, err) in
                
                var yourHighScore: Int64 = 0
                if let yourCurrentRank = playersScores?.first?.rank {
                    print("Is this your global rank?", yourCurrentRank)
                }
                if let yourCHighScore = playersScores?.first?.value {
                    yourHighScore = yourCHighScore
                    print("Is this your score?", yourHighScore)
                }
                if let dateEarned = playersScores?.first?.date {
                    print("Date last earned?", dateEarned)
                }
                if let playerName = playersScores?.first?.player.displayName {
                    print("Is this your name...?", playerName)
                }
                
                print("Change highscore from", yourHighScore, "to", willDo(Int(yourHighScore)))
                setHighscore(number: willDo(Int(yourHighScore)), leaderboard: this, context: context)
            }
            
        }

    }
    
    // top `n` highscores?
//    leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...100)) { entry, _, _, error  in
//        completion(entry?.score)
//    }
//
    
    // MARK: - REPORT ACHIEVEMENT -
    
    static func achieve(_ this: Achievements) {
        let achievement = GKAchievement.init(identifier: this.rawValue, player: GKLocalPlayer.local)
        achievement.showsCompletionBanner = true
        achievement.percentComplete = 100
        report([achievement])
    }
    
    static func achieve(_ this: Achievements, percentageComplete: @escaping (Double) -> Double) {
        
        GKAchievement.loadAchievements { achieves, _ in
            let achievement = achieves?.filter({ $0.identifier == this.rawValue }).first ?? GKAchievement.init(identifier: this.rawValue, player: GKLocalPlayer.local)
            achievement.showsCompletionBanner = true
            let changingTo = percentageComplete(achievement.percentComplete)
            print("Changing percentage from \(achievement.percentComplete) to \(changingTo)")
            achievement.percentComplete = changingTo
            report([achievement])
        }
        
        
//            achievement.lastReportedDate
//            achievement.percentComplete
//            achievement.isCompleted
//            achievement.player
//            achievement.showsCompletionBanner
//            achievement.
        
//        GKLeaderboard.loadLeaderboards(IDs: [this.rawValue]) { leaderboards, error in
//        GKAchievement.loadAchievements { this, _ in
//            this
//        }
        
//        let achievement = GKAchievement.init(identifier: this.rawValue, player: GKLocalPlayer.local)
//        achievement.showsCompletionBanner = true
//        achievement.percentComplete = percentageComplete(achievement.percentComplete)
//        report([achievement])
    }
    
    private static func report(_ theseAchievements: [GKAchievement]) {
        GKAchievement.report(theseAchievements, withCompletionHandler: {(error: Error?) in
            if error != nil {
               // Handle the error that occurs.
               print("Error: \(String(describing: error))")
           }
       })
    }
    
}

// MARK: - Open Game Center -
extension GameCenterHelper: OpenGameCenter {
    
    // Present the Leaderboard Scene, open a specific leaderboard
    static func openLeaderboard(_ board: Leaderboards) {
        DispatchQueue.main.sync {
            Self.viewingDashboard = true
            let viewController: GKGameCenterViewController
            
            if #available(iOS 14.0, *, macOS 11.0, *) {
                // macOS 11.0, iOS 14.0 - NEW WAY TO open leaderboards
                viewController = GKGameCenterViewController(leaderboardID: board.rawValue, playerScope: .global, timeScope: .allTime)
                
            } else {
                // old way to open leaderboards
                viewController = GKGameCenterViewController()
                viewController.viewState = .leaderboards
                viewController.leaderboardIdentifier = board.rawValue
            }
            
            viewController.gameCenterDelegate = helper
            
            #if os(macOS)
            helper.viewController?.present(viewController, animator: ReplacePresentationAnimator())
            #elseif os(iOS)
            helper.viewController?.present(viewController, animated: true)
            #endif
        }
    }
    
    static func openAchievement(_ achievement: Achievements) {
        Self.viewingDashboard = true
        let viewController: GKGameCenterViewController
        
        if #available(iOS 14.0, *, macOS 11.0, *) {
            // macOS 11.0, iOS 14.0 - NEW WAY TO open leaderboards
            viewController = GKGameCenterViewController.init(achievementID: achievement.rawValue)
            
        } else {
            // old way to open leaderboards
            viewController = GKGameCenterViewController()
            viewController.viewState = .achievements
        }
        
        viewController.gameCenterDelegate = helper
        #if os(macOS)
        helper.viewController?.present(viewController, animator: ReplacePresentationAnimator())
        #elseif os(iOS)
        helper.viewController?.present(viewController, animated: true)
        #endif
    }
    
    // Open and Present Game Center
    static func openGameCenter() {
        Self.viewingDashboard = true
        let viewController = GKGameCenterViewController.init() // present the main
        viewController.gameCenterDelegate = helper
        #if os(macOS)
        helper.viewController?.present(viewController, animator: ReplacePresentationAnimator())
        #elseif os(iOS)
        helper.viewController?.present(viewController, animated: true)
        #endif
    }
    
    // The GameCenter Controller is being exited, and returning to the game.
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        Self.viewingDashboard = false
        #if os(macOS)
        gameCenterViewController.dismiss(true)
        #elseif os(iOS)
        gameCenterViewController.dismiss(animated: true)
        #endif
    }
    
}


// MARK: - MacOS View Controller Presentation Animation -
#if os(macOS)
class ReplacePresentationAnimator: NSObject, NSViewControllerPresentationAnimator {
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        if let window = fromViewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                fromViewController.view.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                viewController.view.alphaValue = 0
                window.contentViewController = viewController
                viewController.view.animator().alphaValue = 1.0
            })
        }
    }

    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        if let window = viewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                viewController.view.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                fromViewController.view.alphaValue = 0
                window.contentViewController = fromViewController
                fromViewController.view.animator().alphaValue = 1.0
            })
        }
    }
}
#endif
