//
//  NilPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class NilPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNil() {
        let input: Int? = nil
        let output = Data([192])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testValue() {
        let input: Int? = -1
        let output = Data([255])
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
