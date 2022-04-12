//
//  Tracker.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/9.
//  Copyright © 2022 Cdts. All rights reserved.
//

import Foundation

class Tracker {
    var steps = [Step]()
    
    func forward(step: Step, draft: Bool) {
        if !draft {
            steps = steps.filter({ $0.index != step.index })
        }
        steps.append(step)
    }
    func back() -> Step? {
        return steps.popLast()
    }
}

struct Step {
    enum StepType {
        case input(value: Int?, draft: Bool)
    }
    let type: StepType
    let index: Int
}
