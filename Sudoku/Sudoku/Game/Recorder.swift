//
//  Recorder.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/2.
//  Copyright © 2022 Cdts. All rights reserved.
//

import Foundation

struct Recorder {
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
    
    static func bestRecoard(by type: SudokuGame.GridType, level: SudokuGame.Level) -> Int? {
        switch type {
        case .nineNine:
            switch level {
            case .easy:
                return easyRecord9
            case .normal:
                return normalRecord9
            case .hard:
                return hardRecord9
            }
        case .sixSix:
            switch level {
            case .easy:
                return easyRecord6
            case .normal:
                return normalRecord6
            case .hard:
                return hardRecord6
            }
        }
    }
    static func newRecord(with newRecord: Int, by type: SudokuGame.GridType, level: SudokuGame.Level) -> Bool {
        let oldRecord = bestRecoard(by: type, level: level)
        if oldRecord == nil || oldRecord == 0 || oldRecord! > newRecord {
            switch type {
            case .nineNine:
                switch level {
                case .easy:
                    easyRecord9 = newRecord
                case .normal:
                    normalRecord9 = newRecord
                case .hard:
                    hardRecord9 = newRecord
                }
            case .sixSix:
                switch level {
                case .easy:
                    easyRecord6 = newRecord
                case .normal:
                    normalRecord6 = newRecord
                case .hard:
                    hardRecord6 = newRecord
                }
            }
            return true
        }
        return false
    }
}
