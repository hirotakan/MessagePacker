//
//  ArrayUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class ArrayUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNilArray() {
        let input = Data([149, 1, 192, 32, 192, 205, 1, 224])
        let output: [Int?] = [1, nil, 32, nil, 480]
        XCTAssertEqual(try decoder.decode(Array.self, from: input), output)
    }

    func testFixArray() {
        let input = Data([147, 1, 205, 7, 208, 206, 1, 107, 8, 108])
        let output = [1 ,2000, 23791724]
        XCTAssertEqual(try decoder.decode(Array.self, from: input), output)
    }

    func test2DimensionalArray() {
        let input = Data([146, 147, 1, 32, 205, 1, 224, 147, 10, 205, 1, 64, 205, 18, 192])
        let output = [[1 ,32, 480],[10 ,320, 4800]]
        XCTAssertEqual(try decoder.decode(Array.self, from: input), output)
    }

    func testBinaryArray() {
        let input = Data([154, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4, 196, 5, 0, 1, 2, 3, 4])
        let output = [Data](repeating: Data([0, 1, 2, 3, 4]), count: 10)
        XCTAssertEqual(try decoder.decode(Array.self, from: input), output)
    }

}
