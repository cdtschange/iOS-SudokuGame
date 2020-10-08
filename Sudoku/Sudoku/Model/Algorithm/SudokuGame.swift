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
                return "normal"
            case .hard:
                return "Hard"
            }
        }
        
        func digCount(of type: GridType) -> Int {
            switch type {
            case .nineNine:
                switch self {
                case .easy:
                    return 30
                case .normal:
                    return 40
                case .hard:
                    return 50
                }
            case .sixSix:
                switch self {
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
    private static var easyRecord9: Int? {
        get { UserDefaults.standard.integer(forKey: "EasyRecord9") }
        set { UserDefaults.standard.set(newValue, forKey: "EasyRecord9") }
    }
    private static var normalRecord9: Int? {
        get { UserDefaults.standard.integer(forKey: "NormalRecord9") }
        set { UserDefaults.standard.set(newValue, forKey: "NormalRecord9") }
    }
    private static var hardRecord9: Int? {
        get { UserDefaults.standard.integer(forKey: "HardRecord9") }
        set { UserDefaults.standard.set(newValue, forKey: "HardRecord9") }
    }
    private static var easyRecord6: Int? {
        get { UserDefaults.standard.integer(forKey: "EasyRecord6") }
        set { UserDefaults.standard.set(newValue, forKey: "EasyRecord6") }
    }
    private static var normalRecord6: Int? {
        get { UserDefaults.standard.integer(forKey: "NormalRecord6") }
        set { UserDefaults.standard.set(newValue, forKey: "NormalRecord6") }
    }
    private static var hardRecord6: Int? {
        get { UserDefaults.standard.integer(forKey: "HardRecord6") }
        set { UserDefaults.standard.set(newValue, forKey: "HardRecord6") }
    }
    
    private var type: GridType
    private var level: Level
    private var data: [SudokuCell]
    
    static func bestRecoard(by recordType: GridType, recordLevel: Level) -> Int? {
        switch recordType {
        case .nineNine:
            switch recordLevel {
            case .easy:
                return easyRecord9
            case .normal:
                return normalRecord9
            case .hard:
                return hardRecord9
            }
        case .sixSix:
            switch recordLevel {
            case .easy:
                return easyRecord6
            case .normal:
                return normalRecord6
            case .hard:
                return hardRecord6
            }
        }
    }
    static func breakRecord(with time: Int, by recordType: GridType, recordLevel: Level) {
        switch recordType {
        case .nineNine:
            switch recordLevel {
            case .easy:
                easyRecord9 = time
            case .normal:
                normalRecord9 = time
            case .hard:
                hardRecord9 = time
            }
        case .sixSix:
            switch recordLevel {
            case .easy:
                easyRecord6 = time
            case .normal:
                normalRecord6 = time
            case .hard:
                hardRecord6 = time
            }
        }
    }
    
    
    /// Create Sudoku Game
    /// - Parameters:
    ///   - type: type
    ///   - level: level
    /// - Returns: (full cell array, digged cell array)
    static func create(by type: GridType, level: Level) -> ([SudokuCell], [SudokuCell]) {
        var sudoku = SudokuGame(type: type, level: level)
        
        var digIndex = [Int]()
        while !sudoku.validate(for: digIndex) {
            sudoku.create()
            digIndex = sudoku.dig()
        }
        return sudoku.package(with: digIndex)
    }
    
    private init(type: GridType, level: Level) {
        self.type = type
        self.level = level
        self.data = []
        switch type {
        case .nineNine:
            for index in 0..<cellInstance.cellCount {
                data.append(Sudoku9x9Cell(index: index))
            }
        case .sixSix:
            for index in 0..<cellInstance.cellCount {
                data.append(Sudoku6x9Cell(index: index))
            }
        }
    }
    
    private var cellInstance: SudokuCell {
        switch type {
        case .nineNine:
            return Sudoku9x9Cell(index: 0)
        case .sixSix:
            return Sudoku6x9Cell(index: 0)
        }
    }
    private mutating func create() {
        fillCell(at: 0, auto: true)
    }
    private func validate(for digIndex: [Int]) -> Bool {
        if data.count != cellInstance.cellCount || data.first(where: { $0.value == nil }) != nil {
            return false
        }
        return true
    }
    
    private func dig() -> [Int] {
        return Array(Array(0..<data.count).shuffled().prefix(level.digCount(of: type)))
    }
    
    private func package(with digIndex: [Int]) -> ([SudokuCell], [SudokuCell]) {
        var output = SudokuGame(type: type, level: level)
        data.forEach { cell in
            if !digIndex.contains(cell.index) {
                output.fillCell(at: cell.index, with: cell.value, auto: false)
            }
        }
        return (data, output.data)
    }
    
    private mutating func fillCell(at index: Int, with value: Int? = nil, auto: Bool = true) {
        let cell = data[index]
        let value = value ?? cell.randomPossibleValue
        data[index].value = value
        data[index].candidates.remove(at: data[index].candidates.firstIndex(of: value)!)
        relatedCell(with: cell).forEach {
            if $0.candidates.contains(value) {
                data[index].friendCellIndex.append($0.index)
                data[$0.index].candidates.remove(at: $0.candidates.firstIndex(of: value)!)
            }
        }
        let invalid = relatedCell(with: cell).filter { $0.candidates.count == 0 && $0.value == nil }.count > 0
        if invalid {
            rollBackCell(at: index)
        } else if index + 1 < cell.cellCount && auto {
            fillCell(at: index + 1)
        }
    }
    
    private mutating func rollBackCell(at index: Int) {
        let cell = data[index]
        let value = cell.value!
        data[index].value = nil
        data[index].friendCellIndex.forEach {
            data[$0].candidates.append(value)
        }
        data[index].friendCellIndex.removeAll()
        if cell.candidates.count == 0 {
            resetCell(at: index)
            rollBackCell(at: index - 1)
        } else {
            fillCell(at: index)
        }
    }
    
    private mutating func resetCell(at index: Int) {
        let cell = data[index]
        data[index].candidates = cell.initialCandidates
        relatedCell(with: cell).forEach { relatedCell in
            if let value = relatedCell.value, data[index].candidates.contains(value) {
                data[index].candidates.remove(at: data[index].candidates.firstIndex(of: value)!)
            }
        }
    }
    
    private func relatedCell(with cell: SudokuCell) -> [SudokuCell] {
        return cell.relateCellIndex.map { data[$0] }
    }
    
}

protocol SudokuCell: CustomStringConvertible {
    var index: Int { get set }
    var value: Int? { get set }
    var candidates: [Int] { get set }
    var friendCellIndex: [Int] { get set }
    var initialCandidates: [Int] { get }
    var cellCount: Int { get }
    var type: SudokuGame.GridType { get }
    
    init(index: Int, value: Int?)
    var row: Int { get }
    var col: Int { get }
    var group: Int { get }
    var relateCellIndex: [Int] { get }
}
extension SudokuCell {
    
    var randomPossibleValue: Int {
        return candidates[Int(arc4random_uniform(UInt32(candidates.count)))]
    }
    
    var relateCellIndex: [Int] {
        switch type {
        case .nineNine:
            return Array(0..<cellCount).filter { ($0.row9 == row || $0.col9 == col || $0.group9 == group) && $0 != index }
        case .sixSix:
            return Array(0..<cellCount).filter { ($0.row6 == row || $0.col6 == col || $0.group6 == group) && $0 != index }
        }
    }
    
    var description: String {
        return "Cell \(index): \(value ?? 0)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}

struct Sudoku9x9Cell: SudokuCell {
    
    var index: Int
    var value: Int?
    var candidates: [Int] = []
    var friendCellIndex: [Int] = []
    var initialCandidates: [Int] { [1,2,3,4,5,6,7,8,9] }
    var cellCount: Int { 81 }
    var type: SudokuGame.GridType { .nineNine }
    
    init(index: Int, value: Int? = nil) {
        self.index = index
        self.value = value
        self.candidates = initialCandidates
    }
    
    var row: Int { index.row9 }
    var col: Int { index.col9 }
    var group: Int { index.group9 }
}
struct Sudoku6x9Cell: SudokuCell {
    
    var index: Int
    var value: Int?
    var candidates: [Int] = []
    var friendCellIndex: [Int] = []
    var initialCandidates: [Int] { [1,2,3,4,5,6] }
    var cellCount: Int { 36 }
    var type: SudokuGame.GridType { .sixSix }
    
    init(index: Int, value: Int? = nil) {
        self.index = index
        self.value = value
        self.candidates = initialCandidates
    }
    
    var row: Int { index.row6 }
    var col: Int { index.col6 }
    var group: Int { index.group6 }
}

extension Int {
    var row9: Int {
        return self / 9
    }
    var col9: Int {
        return self % 9
    }
    var group9: Int {
        if col9 < 3 && row9 < 3 {
            return 1
        } else if (col9 < 6 && col9 >= 3) && row9 < 3 {
            return 2
        } else if (col9 < 9 && col9 >= 6) && row9 < 3 {
            return 3
        } else if (col9 < 3) && (row9 < 6 && row9 >= 3) {
            return 4
        } else if (col9 < 6 && col9 >= 3) && (row9 < 6 && row9 >= 3) {
            return 5
        } else if (col9 < 9 && col9 >= 6) && (row9 < 6 && row9 >= 3) {
            return 6
        } else if (col9 < 3) && (row9 < 9 && row9 >= 6) {
            return 7
        } else if (col9 < 6 && col9 >= 3) && (row9 < 9 && row9 >= 6) {
            return 8
        } else if (col9 < 9 && col9 >= 6) && (row9 < 9 && row9 >= 6) {
            return 9
        }
        return 0
    }
    
    var row6: Int {
        return self / 6
    }
    var col6: Int {
        return self % 6
    }
    var group6: Int {
        if col6 < 3 && row6 < 2 {
            return 1
        } else if (col6 < 6 && col6 >= 3) && row6 < 2 {
            return 2
        } else if (col6 < 3) && (row6 < 4 && row6 >= 2) {
            return 3
        } else if (col6 < 6 && col6 >= 3) && (row6 < 4 && row6 >= 2) {
            return 4
        } else if (col6 < 3) && (row6 < 6 && row6 >= 4) {
            return 5
        } else if (col6 < 6 && col6 >= 3) && (row6 < 6 && row6 >= 4) {
            return 6
        }
        return 0
    }
}
