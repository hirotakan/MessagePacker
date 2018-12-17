//
//  TimestampUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/19.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class TimestampUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTimestamp32() {
        let input = Data([214, 255, 0, 0, 0, 1])
        let output = MessagePackTimestamp(seconds: 1, nanoseconds: 0)
        XCTAssertEqual(try decoder.decode(MessagePackTimestamp.self, from: input), output)
    }

    func testTimestamp64() {
        let input = Data([215, 255, 50, 1, 148, 236, 91, 242, 22, 42])
        let output = MessagePackTimestamp(seconds: 1542592042, nanoseconds: 209741115)
        XCTAssertEqual(try decoder.decode(MessagePackTimestamp.self, from: input), output)
    }

    func testTimestamp96() {
        let input = Data([199, 12, 255, 25, 69, 229, 222, 0, 0, 0, 14, 211, 132, 20, 74])
        let output = MessagePackTimestamp(seconds: 63678190666, nanoseconds: 424011230)
        XCTAssertEqual(try decoder.decode(MessagePackTimestamp.self, from: input), output)
    }
}
