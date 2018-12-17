//
//  BoolPackedTests.swift
//  MessagePackerTests
//
//  Created by hirotaka on 2018/11/12.
//  Copyright © 2018 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class BoolPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFalse() {
        let input = false
        let output = Data([194])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testTrue() {
        let input = true
        let output = Data([195])
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
