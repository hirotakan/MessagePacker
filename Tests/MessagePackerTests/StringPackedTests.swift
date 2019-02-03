//
//  StringPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/12.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class StringPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFixString() {
        let input = "Hello, world!"
        let output = Data([173]) + input.data(using: .utf8)!
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixString8() {
        let input = String(repeating: "Hello, world!", count: 2)
        let output = Data([217, 26]) + input.data(using: .utf8)!
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixString16() {
        let input = String(repeating: "Hello, world!", count: 20)
        let output = Data([218, 1, 4]) + input.data(using: .utf8)!
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixString32() {
        let input = String(repeating: "Hello, world!", count: 5050)
        let output = Data([219, 0, 1, 0, 114] + input.data(using: .utf8)!)
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
