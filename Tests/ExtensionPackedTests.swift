//
//  ExtensionPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class ExtensionPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFixext1() {
        let input = MessagePackExtension(type: 5, data: Data([0]))
        let output = Data([212, 5, 0])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixext2() {
        let input = MessagePackExtension(type: 5, data: Data([0, 1]))
        let output = Data([0xd5, 0x05, 0x00, 0x01])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixext4() {
        let input = MessagePackExtension(type: 5, data: Data([0, 1, 2, 3]))
        let output = Data([0xd6, 0x05, 0x00, 0x01, 0x02, 0x03])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixext8() {
        let input = MessagePackExtension(type: 5, data: Data([0, 1, 2, 3, 4, 5, 6, 7]))
        let output = Data([0xd7, 0x05, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixext16() {
        let input = MessagePackExtension(type: 5, data: Data([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]))
        let output = Data([0xd8, 0x05, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testExt8() {
        let data = Data(count: 7)
        let input = MessagePackExtension(type: 5, data: data)
        let output = Data([0xc7, 0x07, 0x05]) + data
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testExt16() {
        let data = Data(count: 0x100)
        let input = MessagePackExtension(type: 5, data: data)
        let output = Data([0xc8, 0x01, 0x00, 0x05]) + data
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testExt32() {
        let data = Data(count: 0x10000)
        let input = MessagePackExtension(type: 5, data: data)
        let output = Data([0xc9, 0x00, 0x01, 0x00, 0x00, 0x05]) + data
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
