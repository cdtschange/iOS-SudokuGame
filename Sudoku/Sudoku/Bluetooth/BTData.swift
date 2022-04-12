//
//  BTData.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/10.
//  Copyright © 2022 Cdts. All rights reserved.
//

import Foundation

enum BTDataType: Int {
    case create, update
}

struct BTData: Codable {
    let type: Int
    let data: [Int]?
    let progress: Double?
    let gridType: Int?
    let level: Int?
    
    public init(type: Int,
          data: [Int]?,
          progress: Double?,
          gridType: Int?,
          level: Int?) {
        self.type = type
        self.data = data
        self.progress = progress
        self.gridType = gridType
        self.level = level
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
        data = try container.decodeIfPresent([Int].self, forKey: .data)
        progress = try container.decodeIfPresent(Double.self, forKey: .progress)
        gridType = try container.decodeIfPresent(Int.self, forKey: .gridType)
        level = try container.decodeIfPresent(Int.self, forKey: .level)
    }
    
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case data = "data"
        case progress = "progress"
        case gridType = "gridType"
        case level = "level"
    }
}
