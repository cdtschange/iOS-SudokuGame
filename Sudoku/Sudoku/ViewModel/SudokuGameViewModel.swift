//
//  SudokuGame.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

class SudokuGameViewModel: ObservableObject {
    @Published private var game: SudokuModel = SudokuGameViewModel.createGame(type: .nineNine, level: .easy)
    var gameCompletion: Bool = false
    @Published var showCongratulations: Bool = false
    var bestRecordEasy9: Int? = SudokuGame.bestRecoard(by: .nineNine, recordLevel: .easy)
    var bestRecordNormal9: Int? = SudokuGame.bestRecoard(by: .nineNine, recordLevel: .normal)
    var bestRecordHard9: Int? = SudokuGame.bestRecoard(by: .nineNine, recordLevel: .hard)
    var bestRecordEasy6: Int? = SudokuGame.bestRecoard(by: .sixSix, recordLevel: .easy)
    var bestRecordNormal6: Int? = SudokuGame.bestRecoard(by: .sixSix, recordLevel: .normal)
    var bestRecordHard6: Int? = SudokuGame.bestRecoard(by: .sixSix, recordLevel: .hard)
    var breakRecord: Bool = false
    
    var soundPlayer = Sounds()
    
    var type: SudokuGame.GridType {
        game.type
    }
    var level: SudokuGame.Level {
        game.level
    }
    var cells: [DigitalCell] {
        game.gameData
    }
    var timeCost: Int {
        game.timeCost
    }
    
    var onCompeltion: (Bool, Int) -> Void {
        return { breakRecord, timeCost in
            self.breakRecord = breakRecord
            if breakRecord {
                switch self.type {
                case .nineNine:
                    switch self.level {
                    case .easy:
                        self.bestRecordEasy9 = timeCost
                    case .normal:
                        self.bestRecordNormal9 = timeCost
                    case .hard:
                        self.bestRecordHard9 = timeCost
                    }
                case .sixSix:
                    switch self.level {
                    case .easy:
                        self.bestRecordEasy6 = timeCost
                    case .normal:
                        self.bestRecordNormal6 = timeCost
                    case .hard:
                        self.bestRecordHard6 = timeCost
                    }
                }
            }
            self.gameCompletion = true
            self.showCongratulations = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.soundPlayer.playSounds(with: .win)
            }
        }
    }
    
    init() {
        game.onCompletion = onCompeltion
    }
    
    @objc func pause() {
        
    }
    
    private static func createGame(type: SudokuGame.GridType, level: SudokuGame.Level) -> SudokuModel {
        return SudokuModel(type: type, level: level)
    }
    
    func select(cell: DigitalCell) {
        if gameCompletion {
            return
        }
        if game.select(cell: cell) {
            soundPlayer.playSounds(with: .click)
        }
    }
    
    func choose(number: Int?, isDraft: Bool) {
        if game.choose(number: number, isDraft: isDraft) {
            soundPlayer.playSounds(with: .select)
        } else {
            soundPlayer.playSounds(with: .error)
        }
    }
    
    func newGame(type: SudokuGame.GridType, level: SudokuGame.Level) {
        gameCompletion = false
        game = SudokuGameViewModel.createGame(type: type, level: level)
        game.onCompletion = onCompeltion
    }
}
