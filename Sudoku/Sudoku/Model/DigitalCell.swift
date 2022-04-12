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
    var value: Int?
    var isOriginal: Bool
    var isDraft: Bool {
        !drafts.isEmpty
    }
    var drafts: Set<Int> = Set() 
    var isConflicted: Bool = false
    var isSelected: Bool = false
    var isRelated: Bool = false
    var isSameValue: Bool = false
    
    var isCorrect: Bool {
        return isOriginal || value != nil && isConflicted == false && isDraft == false
    }
    var displayValue: String {
        return value == nil ? "" : "\(value!)"
    }
    
    init(model: SudokuCell, isOriginal: Bool) {
        self.id = model.index
        self.value = model.value
        self.isOriginal = isOriginal
    }
    
    static func == (lhs: DigitalCell, rhs: DigitalCell) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
