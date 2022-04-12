//
//  SudokuGame.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI


class SudokuGameViewModel: ObservableObject {
    @Published private var game: SudokuGame!
    @Published private(set) var cells: [DigitalCell] = []
    @Published private(set) var time: Int = 0
    @Published var isDraft: Bool = false
    @Published var showCongratulations: Bool = false
    @Published var breakRecord: Bool = false
    @Published var paused: Bool = false
    
    var type: SudokuGame.GridType
    var level: SudokuGame.Level
    var music = true
    var battle = false
    
    private var currentIndex: Int?
    private var soundPlayer: Sounds?
    private var soundBGPlayer: Sounds?
    private var timer = GameTimer()
    private var tracker = Tracker()
    private var started = false
    
    var finished: Bool = false
    var bestRecordEasy: Int? { Recorder.bestRecoard(by: type, level: .easy) }
    var bestRecordNormal: Int? { Recorder.bestRecoard(by: type, level: .normal) }
    var bestRecordHard: Int? { Recorder.bestRecoard(by: type, level: .hard) }
    
    var progress: Double {
        return Double(cells.filter({ !$0.isOriginal && $0.isCorrect }).count) / Double(cells.filter({ !$0.isOriginal }).count)
    }
    
    
    init(type: SudokuGame.GridType, level: SudokuGame.Level, music: Bool, battle: Bool) {
        self.type = type
        self.level = level
        self.music = music
        self.battle = battle
    }
    
    func generateGame() -> [Int] {
        self.game = SudokuGame(type: type, level: level)
        return self.game.export()
    }
   
    func newGame(type: SudokuGame.GridType? = nil, level: SudokuGame.Level? = nil, source: [Int]? = nil) {
        if started {
            return
        }
        if let type = type {
            self.type = type
        }
        if let level = level {
            self.level = level
        }
        self.soundPlayer = music ? Sounds() : nil
        self.soundBGPlayer = music ? Sounds() : nil
        self.game = SudokuGame(type: self.type, level: self.level, source: source)
        started = true
        breakRecord = false
        finished = false
        time = 0
        isDraft = false
        showCongratulations = false
        paused = false
        tracker = Tracker()
        
        print("New Game: \(self.type) \(self.level)")
        
        cells = [DigitalCell]()
        for cell in game.data {
            cells.append(DigitalCell(model: cell, isOriginal: game.isOriginal(of: cell.index)))
        }
        timer.start() { time in
            self.time = time
        }
        
        playMusic()
    }
    
    func playMusic() {
        soundBGPlayer?.playSounds(with: .background, needRepeat: true)
    }
    
    func stop() {
        soundBGPlayer?.stop()
        timer.stop()
        started = false
    }
    
    func pause() {
        paused.toggle()
        if paused {
            soundBGPlayer?.pause()
            timer.pause()
        } else {
            soundBGPlayer?.resume()
            timer.resume()
        }
    }
    
    private func unselectCell() {
        if let currentIndex = currentIndex {
            cells[currentIndex].isSelected = false
            let relatedIndexes = game.data[currentIndex].relateIndex
            for relatedIndex in relatedIndexes {
                cells[relatedIndex].isSameValue = false
                cells[relatedIndex].isRelated = false
            }
        }
        currentIndex = nil
    }
    
    func select(cell: DigitalCell?) {
        guard !finished && !paused else {
            return
        }
        guard let cell = cell else {
            unselectCell()
            return
        }
        print("\(cell.isSelected ? "Unselect:" : "Select:") \(cell.id)")
        cells[cell.id].isSelected.toggle()
        if let currentIndex = currentIndex, currentIndex != cell.id {
            cells[currentIndex].isSelected = false
        }
        currentIndex = cells[cell.id].isSelected ? cell.id : nil
        let relatedIndexes = game.data[cell.id].relateIndex
        for c in cells {
            if !cells[cell.id].isSelected {
                cells[c.id].isSameValue = false
                cells[c.id].isRelated = false
                continue
            }
            cells[c.id].isSameValue = cell.value != nil && c.value == cell.value
            cells[c.id].isRelated = relatedIndexes.contains(c.id)
        }
        
        soundPlayer?.playSounds(with: .click)
    }
    
    func clearSelectedValue() {
        input(value: nil)
    }
    func undo() {
        guard !finished && !paused else {
            return
        }
        if let step = tracker.back() {
            select(cell: nil)
            switch step.type {
            case .input(let value, let draft):
                isDraft = draft
                currentIndex = step.index
                if draft {
                    input(value: value, track: false)
                } else {
                    input(value: nil, track: false)
                }
            }
        }
    }
    
    func input(value: Int?, track: Bool = true) {
        guard let index = currentIndex else {
            return
        }
        guard !finished && !paused && !game.isOriginal(of: index) else {
            return
        }
        if track {
            tracker.forward(step: Step(type: .input(value: value, draft: isDraft), index: index), draft: isDraft)
        }
        game.fillCell(with: value, index: index, draft: isDraft)
        if isDraft {
            cells[index].value = nil
            if let value = value {
                if cells[index].drafts.contains(value) {
                    cells[index].drafts.remove(value)
                } else {
                    cells[index].drafts.insert(value)
                }
            } else {
                cells[index].drafts.removeAll()
            }
            return
        } else {
            cells[index].value = value
            cells[index].drafts.removeAll()
        }
        guard !game.data[index].isConflicted(data: game.data) else {
            cells[index].isConflicted = true
            soundPlayer?.playSounds(with: .error)
            return
        }
        let relatedIndexes = game.data[index].relateIndex
        for relatedIndex in relatedIndexes {
            cells[relatedIndex].isConflicted = game.data[relatedIndex].isConflicted(data: game.data)
        }
        cells[index].isConflicted = false
        if value != nil {
            soundPlayer?.playSounds(with: .select)
        }
        
        if game.isFinished {
            cells[index].isSelected = false
            unselectCell()
            onComplete()
        }
    }
    
    func onComplete() {
        timer.stop()
        breakRecord = Recorder.newRecord(with: time, by: type, level: level)
        self.finished = true
        self.showCongratulations = true
        self.soundBGPlayer?.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.soundPlayer?.playSounds(with: .win)
        }
        
    }
    func onFailure() {
        timer.stop()
        self.finished = true
        self.soundBGPlayer?.stop()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.soundPlayer?.playSounds(with: .win)
//        }
        
    }
}

extension Int {
    var displayTime: String {
        if self <= 0 {
            return "00:00"
        }
        return String(format:"%02d:%02d",
                      self / 60,
                      self % 60)
    }
    var recordTime: String {
        if self <= 0 {
            return "--:--"
        }
        return String(format:"%02d:%02d",
                      self / 60,
                      self % 60)
    }
}

//extension Double {
//    var displayTimeFlash: String {
//        if self == Double(Int(self)) {
//            return String(format:"%02d:%02d",
//                          Int(self) / 60,
//                          Int(self) % 60)
//        } else {
//            return String(format:"%02d %02d",
//                          Int(self) / 60,
//                          Int(self) % 60)
//        }
//    }
//}
