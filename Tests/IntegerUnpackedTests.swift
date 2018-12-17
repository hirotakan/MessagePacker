//
//  IntegerUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class IntegerUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNegativeFixint() {
        let input = Data([255])
        let output = -1
        XCTAssertEqual(try decoder.decode(Int.self, from: input), output)
    }

    func testPositiveFixint() {
        let input = Data([1])
        let output = 1
        XCTAssertEqual(try decoder.decode(Int.self, from: input), output)
    }

    func testInt8() {
        let input = Data([208, 129])
        let output = -127
        XCTAssertEqual(try decoder.decode(Int.self, from: input), output)
        XCTAssertEqual(try decoder.decode(Int8.self, from: input), Int8(output))
    }

    func testUInt8() {
        let input = Data([204, 255])
        let output: UInt = 255
        XCTAssertEqual(try decoder.decode(UInt.self, from: input), output)
        XCTAssertEqual(try decoder.decode(UInt8.self, from: input), UInt8(output))
    }

    func testInt16() {
        let input = Data([209, 128, 1])
        let output = -32767
        XCTAssertEqual(try decoder.decode(Int.self, from: input), output)
        XCTAssertEqual(try decoder.decode(Int16.self, from: input), Int16(output))
    }

    func testUInt16() {
        let input = Data([205, 255, 255])
        let output: UInt = 65535
        XCTAssertEqual(try decoder.decode(UInt.self, from: input), output)
        XCTAssertEqual(try decoder.decode(UInt16.self, from: input), UInt16(output))
    }

    func testInt32() {
        let input = Data([210, 255, 255, 0, 0])
        let output = -65536
        XCTAssertEqual(try decoder.decode(Int.self, from: input), output)
        XCTAssertEqual(try decoder.decode(Int32.self, from: input), Int32(output))
    }

    func testUInt32() {
        let input = Data([206, 255, 255, 255, 255])
        let output: UInt = 4294967295
        XCTAssertEqual(try decoder.decode(UInt.self, from: input), output)
        XCTAssertEqual(try decoder.decode(UInt32.self, from: input), UInt32(output))
    }

    func testInt64() {
        let input = Data([211, 255, 255, 255, 255, 0, 0, 0, 0])
        let output = -4294967296
        XCTAssertEqual(try decoder.decode(Int.self, from: input), output)
        XCTAssertEqual(try decoder.decode(Int64.self, from: input), Int64(output))
    }

    func testUInt64() {
        let input = Data([207, 255, 255, 255, 255, 255, 255, 255, 255])
        let output: UInt = 18446744073709551615
        XCTAssertEqual(try decoder.decode(UInt.self, from: input), output)
        XCTAssertEqual(try decoder.decode(UInt64.self, from: input), UInt64(output))
    }
}
