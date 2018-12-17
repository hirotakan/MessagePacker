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
        let output = Data([173, 72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33])
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
