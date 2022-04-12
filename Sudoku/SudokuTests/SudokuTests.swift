//
//  SudokuTests.swift
//  SudokuTests
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import XCTest
@testable import Sudoku

class SudokuTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test9x9CreateGame() {
        let data = Sudoku9x9Cell.create()
        assert(data.count == 81)
        let valid = Sudoku9x9Cell.validate(data: data)
        assert(valid)
    }
    
    func test6x6CreateGame() {
        let data = Sudoku6x6Cell.create()
        assert(data.count == 36)
        let valid = Sudoku6x6Cell.validate(data: data)
        assert(valid)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
