//
//  Sudoku9x9.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/2.
//  Copyright © 2022 Cdts. All rights reserved.
//

import Foundation

struct Sudoku9x9Cell: SudokuCell {
    
    init(index: Int, value: Int? = nil) {
        self.index = index
        self.value = value
        self.candidates = Sudoku9x9Cell.initialCandidates
    }
    
    let index: Int
    var value: Int?
    
    var candidates: [Int] = []
    var type: SudokuGame.GridType { .nineNine }
    
    var row: Int { index.row }
    var col: Int { index.col }
    var group: Int { index.group }
    
    // index of the cell which contains the same candidates
    var friendIndex: [Int] = []
    // index of the cell which has the same row or col or group
    var relateIndex: [Int] {
        return Array(0..<Sudoku9x9Cell.cellCount).filter({ $0 != index && ($0.row == row || $0.col == col || $0.group == group) })
    }
    
    static var initialCandidates: [Int] { [1,2,3,4,5,6,7,8,9] }
    static var cellCount: Int { 81 }
    
    static func initData() -> [SudokuCell] {
        var data = [SudokuCell]()
        for i in 0..<Sudoku9x9Cell.cellCount {
            data.append(Sudoku9x9Cell(index: i))
        }
        return data
    }
    
}

extension Int {
    fileprivate var row: Int {
        return self / 9
    }
    fileprivate var col: Int {
        return self % 9
    }
    fileprivate var group: Int {
        if row < 3 {
            if col < 3 {
                return 1
            } else if col < 6 {
                return 2
            } else {
                return 3
            }
        } else if row < 6 {
            if col < 3 {
                return 4
            } else if col < 6 {
                return 5
            } else {
                return 6
            }
        } else {
            if col < 3 {
                return 7
            } else if col < 6 {
                return 8
            } else {
                return 9
            }
        }
    }
}
