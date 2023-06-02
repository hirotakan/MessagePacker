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

    func testTimestamp32() {
        let input = MessagePackTimestamp(seconds: 1, nanoseconds: 0)
        let output = Data([214, 255, 0, 0, 0, 1])
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
    
    func testTimestamp96WithNegativeDate() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: "0023-09-24T00:36:30.078Z")!
        
        let timestamp = MessagePackTimestamp(date: date)
        let encoded = try encoder.encode(timestamp)
        let decoded = try MessagePackDecoder().decode(MessagePackTimestamp.self, from: encoded)
        XCTAssertEqual(date, Date(timestamp: decoded))
    }
}
