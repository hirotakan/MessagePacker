//
//  ArrayPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class ArrayPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNilArray() {
        let input: [Int?] = [1, nil, 32, nil, 480]
        let output = Data([149, 1, 192, 32, 192, 205, 1, 224])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixArray() {
        let input = [1 ,2000, 23791724]
        let output = Data([147, 1, 205, 7, 208, 206, 1, 107, 8, 108])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func test2DimensionalArray() {
        let input = [[1 ,32, 480],[10 ,320, 4800]]
        let output = Data([146, 147, 1, 32, 205, 1, 224, 147, 10, 205, 1, 64, 205, 18, 192])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    // TODO: Data型のテスト
    func testBinaryArray() {
        let input = [Data](repeating: Data([0, 1, 2, 3, 4]), count: 10)
        let output = Data([154, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4])
        XCTAssertEqual(try encoder.encode(input), output)
    }

}
