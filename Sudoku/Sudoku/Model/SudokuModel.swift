//
//  SudokuModel.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import Foundation

struct SudokuModel {
    
    class TimerHandler {
        var timer: Timer?
        var timeCost: Int = 0
        
        @objc func fireTimer() {
            timeCost += 1
        }
    }
    
    /// User playing game input numbers
    private(set) var gameData: [DigitalCell]
    private(set) var type: SudokuGame.GridType
    private(set) var level: SudokuGame.Level
    var timeCost: Int {
        timerHandler.timeCost
    }
    private var timerHandler: TimerHandler = TimerHandler()
    var onCompletion: ((Bool, Int) -> Void)?
    
    init(type: SudokuGame.GridType, level: SudokuGame.Level) {
        self.type = type
        self.level = level
        print("New game: \(type) \(level)")
        
        gameData = [DigitalCell]()
        let (source, data) = SudokuGame.create(by: type, level: level)
        for (index, value) in data.enumerated() {
            gameData.append(DigitalCell(model: value, originalValue: source[index].value!))
        }
        timerHandler.timer = Timer.scheduledTimer(timeInterval: 1.0, target: timerHandler, selector: #selector(TimerHandler.fireTimer), userInfo: nil, repeats: true)

    }
    
    var indexOfSelectedCell: Int? {
        get { gameData.indices.filter { gameData[$0].isSelected }.only }
        set {
            for index in gameData.indices {
                gameData[index].isSelected = index == newValue
            }
        }
    }
    
    mutating func select(cell: DigitalCell) -> Bool {
        print("Select \(cell.id)")
        if let index = gameData.firstIndex(matching: cell), !gameData[index].isFixedValue {
            if !gameData[index].isSelected {
                indexOfSelectedCell = index
            } else {
                indexOfSelectedCell = nil
            }
            return true
        }
        return false
    }
    
    mutating func choose(number: Int?, isDraft: Bool) -> Bool {
        if let selectIndex = indexOfSelectedCell {
            print("Input \(number ?? 0) in \(selectIndex)")
            gameData[selectIndex].inputValue = number
            gameData[selectIndex].isDraft = isDraft
            if validate(cell: gameData[selectIndex]) {
                gameData[selectIndex].isConflicted = false
                gameData[selectIndex].relateCellIndex.map { gameData[$0] }.filter { $0.isConflicted }.forEach { cell in
                    if validate(cell: cell) {
                        gameData[cell.id].isConflicted = false
                    }
                }
                if isGameFinished {
                    completeGame()
                }
            } else {
                gameData[selectIndex].isConflicted = true
            }
            return !gameData[selectIndex].isConflicted
        }
        return false
    }
    
    func validate(cell: DigitalCell) -> Bool {
        return cell.inputValue == nil || cell.relateCellIndex.map { gameData[$0] }.first { $0.inputValue == cell.inputValue } == nil
    }
    
    var isGameFinished: Bool {
        gameData.filter { $0.isCorrect }.count == gameData.count
    }
    
    mutating func completeGame() {
        indexOfSelectedCell = nil
        print("Congratulations")
        timerHandler.timer?.invalidate()
        let record = SudokuGame.bestRecoard(by: type, recordLevel: level)
        var breakRecord = false
        if record == nil || record == 0 || timeCost < record! {
            SudokuGame.breakRecord(with: timeCost, by: type, recordLevel: level)
            breakRecord = true
        }
        onCompletion?(breakRecord, timeCost)
    }
    
    func bestRecord(by recordType: SudokuGame.GridType, recordLevel: SudokuGame.Level) -> Int? {
        return SudokuGame.bestRecoard(by: type, recordLevel: level)
    }
    
}

extension Int {
    var timeDisplay: String {
        if self <= 0 {
            return "No record"
        }
        return String(format:"%02d:%02d",
                      self / 60,
                      self % 60)
    }
}

extension Double {
    var timeDisplayForTimer: String {
        if self == Double(Int(self)) {
            return String(format:"%02d:%02d",
                          Int(self) / 60,
                          Int(self) % 60)
        } else {
            return String(format:"%02d %02d",
                          Int(self) / 60,
                          Int(self) % 60)
        }
    }
}
