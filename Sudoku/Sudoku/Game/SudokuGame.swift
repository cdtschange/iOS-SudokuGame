//
//  SudokuAlgorithm.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import Foundation

struct SudokuGame {
    
    enum GridType: Int, CaseIterable {
        case nineNine
        case sixSix
        
        var displayName: String {
            switch self {
            case .nineNine:
                return "9 x 9"
            case .sixSix:
                return "6 x 6"
            }
        }
        
        var count: Int {
            switch self {
            case .nineNine:
                return 81
            case .sixSix:
                return 36
            }
        }
    }
    enum Level: Int, CaseIterable {
        case easy
        case normal
        case hard
        
        var displayName: String {
            switch self {
            case .easy:
                return "Easy"
            case .normal:
                return "Normal"
            case .hard:
                return "Hard"
            }
        }
    }
    
    private var type: GridType
    private var level: Level
    private(set) var data: [SudokuCell]
    private var originalIndexes: Set<Int>
    private var draftData: [Int: Set<Int>]
    
    /// Create Sudoku Game
    /// - Parameters:
    ///   - type: type
    ///   - level: level
    init(type: GridType, level: Level, source: [Int]? = nil) {
        self.type = type
        self.level = level
        if let source = source, source.count == type.count {
            self.data = SudokuGame.importGame(by: type, level: level, source: source)
        } else {
            self.data = SudokuGame.createGame(by: type, level: level)
        }
        self.originalIndexes = Set()
        self.draftData = [:]
        for cell in data {
            if cell.value != nil {
               originalIndexes.insert(cell.index)
           }
        }
    }
    
    func export() -> [Int] {
        return data.map { $0.value ?? 0 }
    }
    
    mutating func fillCell(with value: Int?, index: Int, draft: Bool = false) {
        guard !originalIndexes.contains(index) else { return }
        if draft {
            data[index].value = nil
            if let value = value {
                if var values = draftData[index],
                   values.contains(value) {
                    values.remove(value)
                    draftData[index] = values
                    return
                }
                var values = draftData[index] ?? Set()
                values.insert(value)
                draftData[index] = values
                return
            }
            return
        }
        draftData[index]?.removeAll()
        data[index].value = value
        updateCandidates()
        draftData.removeValue(forKey: index)
    }
    
    func isOriginal(of index: Int) -> Bool {
        return originalIndexes.contains(index)
    }
    
    func isDraft(of index: Int) -> Bool {
        return !(draftData[index]?.isEmpty ?? true)
    }
    
    var isFinished: Bool {
        for cell in data {
            if isOriginal(of: cell.index) {
                continue
            }
            if cell.value == nil || isDraft(of: cell.index) || cell.isConflicted(data: data) {
                return false
            }
        }
        return true
    }
    
    private mutating func updateCandidates() {
        for cell in data {
            var cell = cell
            cell.updateCandidates(data: data)
            data[cell.index] = cell
        }
    }
    
    
    static func createGame(by type: SudokuGame.GridType, level: SudokuGame.Level) -> [SudokuCell] {
        var data = [SudokuCell]()
        switch type {
        case .nineNine:
            data = Sudoku9x9Cell.create()
        case .sixSix:
            data = Sudoku6x6Cell.create()
        }
        data = dig(data: data, by: type, level: level)
        return data
    }
    static func importGame(by type: SudokuGame.GridType, level: SudokuGame.Level, source: [Int]) -> [SudokuCell] {
        var data = [SudokuCell]()
        for (index, value) in source.enumerated() {
            var cell: SudokuCell!
            switch type {
            case .nineNine:
                cell = Sudoku9x9Cell(index: index)
            case .sixSix:
                cell = Sudoku6x6Cell(index: index)
            }
            if value == 0 {
                cell.value = nil
            } else {
                cell.value = value
            }
            data.append(cell)
        }
        // Update candidates
        for cell in data {
            var cell = cell
            cell.updateCandidates(data: data)
            data[cell.index] = cell
        }
        return data
    }
    private static func dig(data: [SudokuCell], by type: SudokuGame.GridType, level: SudokuGame.Level) -> [SudokuCell] {
        var data = data
        let emptyIndexes = (0..<data.count).shuffled().prefix(emptyCount(for: type, level: level))
        // Dig cell
        for cell in data {
            if emptyIndexes.contains(cell.index) {
                data[cell.index].value = nil
            }
        }
        // Update candidates
        for cell in data {
            var cell = cell
            cell.updateCandidates(data: data)
            data[cell.index] = cell
        }
        return data
    }
    
    private static func emptyCount(for type: SudokuGame.GridType, level: SudokuGame.Level) -> Int {
        switch type {
        case .nineNine:
            switch level {
            case .easy:
                return 30
            case .normal:
                return 40
            case .hard:
                return 50
            }
        case .sixSix:
            switch level {
            case .easy:
                return 10
            case .normal:
                return 18
            case .hard:
                return 26
            }
        }
    }
}
