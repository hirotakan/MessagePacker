//
//  StringUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/12.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class StringUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFixString() {
        let input = Data([173, 72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33])
        let output = "Hello, world!"
        XCTAssertEqual(try decoder.decode(String.self, from: input), output)
    }

    func testFixString8() {
        let output = String(repeating: "Hello, world!", count: 2)
        let input = Data([217, 26]) + output.data(using: .utf8)!
        XCTAssertEqual(try decoder.decode(String.self, from: input), output)
    }

    func testFixString16() {
        let output = String(repeating: "Hello, world!", count: 20)
        let input = Data([218, 1, 4]) + output.data(using: .utf8)!
        XCTAssertEqual(try decoder.decode(String.self, from: input), output)
    }

    func testFixString32() {
        let output = String(repeating: "Hello, world!", count: 5050)
        let input = Data([219, 0, 1, 0, 114] + output.data(using: .utf8)!)
        XCTAssertEqual(try decoder.decode(String.self, from: input), output)
    }

    func testEmptyString() {
        let input = Data([160])
        let output = ""
        XCTAssertEqual(try decoder.decode(String.self, from: input), output)
    }
}
