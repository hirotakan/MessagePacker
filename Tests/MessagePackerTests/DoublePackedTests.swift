//
//  DoublePackedTests.swift
//  MessagePackerTests
//
//  Created by hirotaka on 2018/11/12.
//  Copyright © 2018 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class DoublePackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDouble() {
        let input = 3.14
        let output = Data([203, 64, 9, 30, 184, 81, 235, 133, 31])
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
