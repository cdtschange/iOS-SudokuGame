//
//  Sudoku6x6.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/2.
//  Copyright © 2022 Cdts. All rights reserved.
//

import Foundation

struct Sudoku6x6Cell: SudokuCell {
    
    let index: Int
    var value: Int?
    var candidates: [Int] = []
    var type: SudokuGame.GridType { .sixSix }
    
    init(index: Int, value: Int? = nil) {
        self.index = index
        self.value = value
        self.candidates = Sudoku6x6Cell.initialCandidates
    }
    
    var row: Int { index.row }
    var col: Int { index.col }
    var group: Int { index.group }
    
    // index of the cell which contains the same candidates
    var friendIndex: [Int] = []
    // index of the cell which has the same row or col or group
    var relateIndex: [Int] {
        return Array(0..<Sudoku6x6Cell.cellCount).filter({ $0 != index && ($0.row == row || $0.col == col || $0.group == group) })
    }
    
    static var initialCandidates: [Int] { [1,2,3,4,5,6] }
    static var cellCount: Int { 36 }
    
    static func initData() -> [SudokuCell] {
        var data = [SudokuCell]()
        for i in 0..<Sudoku6x6Cell.cellCount {
            data.append(Sudoku6x6Cell(index: i))
        }
        return data
    }
}

extension Int {
    fileprivate var row: Int {
        return self / 6
    }
    fileprivate var col: Int {
        return self % 6
    }
    fileprivate var group: Int {
        if row < 2 {
            if col < 3 {
                return 1
            } else {
                return 2
            }
        } else if row < 4 {
            if col < 3 {
                return 3
            } else {
                return 4
            }
        } else {
            if col < 3 {
                return 5
            } else {
                return 6
            }
        }
    }
}
