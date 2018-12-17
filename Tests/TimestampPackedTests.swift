//
//  TimestampPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/19.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class TimestampPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTest1() {
        let input = MessagePackTimestamp(seconds: 1, nanoseconds: 0)
        let output = Data([
            0xd6, UInt8(bitPattern: -1),
            0x00, 0x00, 0x00, 0x01])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testTest2() {
        let input = MessagePackTimestamp(seconds: 0x0003_ffff_ffff, nanoseconds: 0x3fff_ffff)
        let output = Data([
            0xd7, UInt8(bitPattern: -1),
            0xff, 0xff, 0xff, 0xff,
            0xff, 0xff, 0xff, 0xff])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testTest3() {
        let input = MessagePackTimestamp(seconds: Int.max, nanoseconds: 1)
        let output = Data([
            0xc7, 12, UInt8(bitPattern: -1),
            0x00, 0x00, 0x00, 0x01,
            0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testTimestamp32() {
        let input = MessagePackTimestamp(seconds: 1542590303, nanoseconds: 0)
        let output = Data([214, 255, 91, 242, 15, 95])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testTimestamp64() {
        let input = MessagePackTimestamp(seconds: 1542592042, nanoseconds: 209741115)
        let output = Data([215, 255, 50, 1, 148, 236, 91, 242, 22, 42])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testTimestamp96() {
        let input = MessagePackTimestamp(seconds: 63678190666, nanoseconds: 424011230)
        let output = Data([199, 12, 255, 25, 69, 229, 222, 0, 0, 0, 14, 211, 132, 20, 74])
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
