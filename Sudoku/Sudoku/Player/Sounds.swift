//
//  Sounds.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import Foundation
import AVFoundation

class Sounds {
    enum Name: String {
        case background, click, select, error, win
    }

    var audioPlayer: AVAudioPlayer?

    func playSounds(with name: Name, type: String = "mp3", needRepeat: Bool = false) {

        if let path = Bundle.main.path(forResource: name.rawValue, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                if needRepeat {
                    audioPlayer?.numberOfLoops = -1
                }
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Play Error")
            }
        }
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    func resume() {
        audioPlayer?.play()
    }
}
