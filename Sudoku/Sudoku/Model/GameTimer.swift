//
//  GameTimer.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/9.
//  Copyright © 2022 Cdts. All rights reserved.
//

import Foundation

class GameTimer {
    private var timer: Timer?
    var time: Int = 0
    var isPause = false
    private var onTicktok: ((Int) -> Void)?
    
    @objc func fireTimer() {
        if !isPause {
            time += 1
            onTicktok?(time)
        }
    }
    
    func start(onTicktok: ((Int) -> Void)? = nil) {
        time = 0
        self.onTicktok = onTicktok
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameTimer.fireTimer), userInfo: nil, repeats: true)
    }
    func stop() {
        timer?.invalidate()
        timer = nil
        self.onTicktok = nil
    }
    func pause() {
        isPause = true
    }
    func resume() {
        isPause = false
    }
}
