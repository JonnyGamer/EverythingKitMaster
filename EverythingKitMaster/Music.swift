//
//  Music.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/28/22.
//

import AVFoundation

protocol MusicType {
    var rawValue: String { get }
}

class Music {
    static let o = Music()
    var player: AVAudioPlayer?
    
    private var currentMusic: String?
    
    func setVolume(_ to: CGFloat) {
        player?.volume = Float(to)
    }
    
    var volumeNormal = true
    func turnDownVolume() {
        if !volumeNormal { return }
        volumeNormal = false
        
        root.run(.change(from: 1.0, to: 0.25, duration: 1.0, action: { i in
            Music.o.setVolume(i)
        }))
    }
    func turnVolumeUp() {
        if volumeNormal { return }
        volumeNormal = true
        root.run(.change(from: 0.25, to: 1.0, duration: 1.0, action: { i in
            Music.o.setVolume(i)
        }))
    }
    
    func playMusic<T: MusicType>(_ what: T) {
        playMusic(what.rawValue)
    }
    func playMusic(_ what: String) {
        
        let o = DispatchQueue.init(label: "fo")
        o.async { [self] in
            
        let newMusic: String = what
        let loops: Int = -1
        let extend: String = "m4a"
        
        if what == currentMusic { return }
            
            player?.pause()
            let url = Bundle.main.url(forResource: newMusic, withExtension: extend)
            do {
                try player = AVAudioPlayer(contentsOf: url!)
                player?.numberOfLoops = loops
                player?.prepareToPlay()
                player?.play()
                currentMusic = newMusic
            } catch {
                fatalError("Bug Somewhere: \(what)")
            }

            // Ease In cool!
            player?.volume = 0.25
            volumeNormal = false
            turnVolumeUp()
            
        }
        
    }
    
    func pause() { player?.pause() }
    
}
