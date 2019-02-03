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
        let output = Data([213, 5, 0, 1])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixext4() {
        let input = MessagePackExtension(type: 5, data: Data([0, 1, 2, 3]))
        let output = Data([214, 5, 0, 1, 2, 3])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixext8() {
        let input = MessagePackExtension(type: 5, data: Data([0, 1, 2, 3, 4, 5, 6, 7]))
        let output = Data([215, 5, 0, 1, 2, 3, 4, 5, 6, 7])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testFixext16() {
        let input = MessagePackExtension(type: 5, data: Data([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]))
        let output = Data([216, 5, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testExt8() {
        let data = Data(count: 7)
        let input = MessagePackExtension(type: 5, data: data)
        let output = Data([199, 7, 5]) + data
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testExt16() {
        let data = Data(count: 0x100)
        let input = MessagePackExtension(type: 5, data: data)
        let output = Data([200, 1, 0, 5]) + data
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testExt32() {
        let data = Data(count: 0x10000)
        let input = MessagePackExtension(type: 5, data: data)
        let output = Data([201, 0, 1, 0, 0, 5]) + data
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
