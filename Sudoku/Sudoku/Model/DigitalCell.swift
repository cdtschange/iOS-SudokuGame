//
//  DigitalCell.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import Foundation

struct DigitalCell: Identifiable, Equatable, Hashable {
    var id: Int
    var originalValue: Int
    var inputValue: Int?
    var isFixedValue: Bool
    var isDraft: Bool = false
    var isConflicted: Bool = false
    var isSelected: Bool = false
    var cellCount: Int
    var type: SudokuGame.GridType
    var relateCellIndex: [Int] {
        switch type {
        case .nineNine:
            return Array(0..<cellCount).filter { ($0.row9 == id.row9 || $0.col9 == id.col9 || $0.group9 == id.group9) && $0 != id }
        case .sixSix:
            return Array(0..<cellCount).filter { ($0.row6 == id.row6 || $0.col6 == id.col6 || $0.group6 == id.group6) && $0 != id }
        }
    }
    
    var isCorrect: Bool {
        return inputValue != nil && isConflicted == false
    }
    var displayValue: String {
        return inputValue == nil ? "" : "\(inputValue!)"
    }
    
    init(model: SudokuCell, originalValue: Int) {
        self.id = model.index
        self.type = model.type
        self.inputValue = model.value
        self.cellCount = model.cellCount
        self.originalValue = originalValue
        self.isFixedValue = model.value != nil
    }
    
    static func == (lhs: DigitalCell, rhs: DigitalCell) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
