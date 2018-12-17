//
//  IntegerPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class IntegerPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNegativeFixint() {
        let input = -1
        let output = Data([255])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testPositiveFixint() {
        let input = 1
        let output = Data([1])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testInt8() {
        let input = -127
        let output = Data([208, 129])
        XCTAssertEqual(try encoder.encode(Int(input)), output)
        XCTAssertEqual(try encoder.encode(Int8(input)), output)
    }

    func testUInt8() {
        let input = 255
        let output = Data([204, 255])
        XCTAssertEqual(try encoder.encode(UInt(input)), output)
        XCTAssertEqual(try encoder.encode(UInt8(input)), output)
    }

    func testInt16() {
        let input = -32767
        let output = Data([209, 128, 1])
        XCTAssertEqual(try encoder.encode(Int(input)), output)
        XCTAssertEqual(try encoder.encode(Int16(input)), output)
    }

    func testUInt16() {
        let input = 65535
        let output = Data([205, 255, 255])
        XCTAssertEqual(try encoder.encode(UInt(input)), output)
        XCTAssertEqual(try encoder.encode(UInt16(input)), output)
    }

    func testInt32() {
        let input = -65536
        let output = Data([210, 255, 255, 0, 0])
        XCTAssertEqual(try encoder.encode(Int(input)), output)
        XCTAssertEqual(try encoder.encode(Int32(input)), output)
    }

    func testUInt32() {
        let input = 4294967295
        let output = Data([206, 255, 255, 255, 255])
        XCTAssertEqual(try encoder.encode(UInt(input)), output)
        XCTAssertEqual(try encoder.encode(UInt32(input)), output)
    }

    func testInt64() {
        let input = -4294967296
        let output = Data([211, 255, 255, 255, 255, 0, 0, 0, 0])
        XCTAssertEqual(try encoder.encode(Int(input)), output)
        XCTAssertEqual(try encoder.encode(Int64(input)), output)
    }

    func testUInt64() {
        let input: UInt = 18446744073709551615
        let output = Data([207, 255, 255, 255, 255, 255, 255, 255, 255])
        XCTAssertEqual(try encoder.encode(input), output)
        XCTAssertEqual(try encoder.encode(UInt64(input)), output)
    }
}
