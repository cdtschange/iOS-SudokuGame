//
//  Sudoku.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/2.
//  Copyright © 2022 Cdts. All rights reserved.
//

import Foundation

protocol SudokuCell: CustomStringConvertible {
    init(index: Int, value: Int?)
    var index: Int { get }
    var value: Int? { get set }
    
    var candidates: [Int] { get set }
    var type: SudokuGame.GridType { get }
    
    var row: Int { get }
    var col: Int { get }
    var group: Int { get }
    
    // index of the cell which has the same row or col or group
    var relateIndex: [Int] { get }
    
    static var initialCandidates: [Int] { get }
    static var cellCount: Int { get }
    
    static func initData() -> [SudokuCell]
    static func create() -> [SudokuCell]
    
    func set(value: Int, for data: [SudokuCell]) -> (Bool, [SudokuCell])
    func reset(data: [SudokuCell]) -> [SudokuCell]
}

extension SudokuCell {
    
    static func create() -> [SudokuCell] {
        var index = 0
        var data = Self.initData()
        var invalidMap = [Int: [Int]]()
        var rollbackTimes = 0
        while index < data.count {
            let cell = data[index]
            let (valid, newData) = cell.setPossibleValue(data: data, invalidValues: invalidMap[index] ?? [])
            if valid {
                data = newData
                index += 1
            } else {
                invalidMap.removeValue(forKey: index)
                index -= 1
                if invalidMap[index] == nil {
                    invalidMap[index] = [data[index].value!]
                } else {
                    invalidMap[index]?.append(data[index].value!)
                }
                data = data[index].reset(data: data)
                rollbackTimes += 1
            }
        }
        print("Create Success: \(data.map { $0.value != nil ? $0.value! : 0 })")
        print("Rollback times: \(rollbackTimes)")
        return data
    }
    
    static func validate(data: [SudokuCell]) -> Bool {
        for cell in data {
            if cell.value == nil || cell.isConflicted(data: data) {
                return false
            }
        }
        return true
    }
    
    mutating func remove(candidate: Int) {
        candidates.removeAll { $0 == candidate }
    }
    
    func isConflicted(data: [SudokuCell]) -> Bool {
        guard let value = value else { return false }
        return relateIndex.map({ data[$0].value }).contains(value)
    }
    
    mutating func updateCandidates(data: [SudokuCell]) {
        let relatedValues = relateIndex
            .map({ data[$0] })
            .filter({ $0.value != nil })
            .map { $0.value }
        candidates = Self.initialCandidates
        candidates.removeAll { relatedValues.contains($0) }
    }
    
    func setPossibleValue(data: [SudokuCell], invalidValues: [Int] = []) -> (Bool, [SudokuCell]) {
        let cell = data[index]
        if let possibleValue = cell.candidates.filter({ !invalidValues.contains($0) }).randomElement() {
            let (valid, newData) = cell.set(value: possibleValue, for: data)
            if valid {
                return (true, newData)
            } else {
                var values = invalidValues
                values.append(possibleValue)
                return setPossibleValue(data: data, invalidValues: values)
            }
        }
        return (false, data)
    }
    
    func tryToSet(value: Int, for data: [SudokuCell]) -> Bool {
        let cell = data[index]
        if !cell.candidates.contains(value) {
            return false
        }
        for relateCell in relateIndex.map({ data[$0] }) {
            if relateCell.value == nil && relateCell.candidates.filter({ $0 != value }).isEmpty {
                return false
            }
        }
        return true
    }
    
    func set(value: Int, for data: [SudokuCell]) -> (Bool, [SudokuCell]) {
        var data = data
        var cell = data[index]
        let valid = tryToSet(value: value, for: data)
        if valid {
            cell.value = value
            cell.candidates.removeAll { $0 == value }
            relateIndex.forEach { data[$0].candidates.removeAll { $0 == value } }
            data[index] = cell
        }
        return (valid, data)
    }
    
    func reset(data: [SudokuCell]) -> [SudokuCell] {
        var data = data
        var cell = data[index]
        if let value = cell.value, !cell.candidates.contains(value) {
            cell.candidates.append(value)
        }
        cell.value = nil
        data[index] = cell
        relateIndex
            .map({ data[$0] })
            .forEach {
                var relatedCell = $0
                relatedCell.updateCandidates(data: data)
                data[$0.index] = relatedCell
            }
        return data
    }
    
    var description: String {
        return "Cell[\(row),\(col)](\(index)): \(value ?? 0)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}
