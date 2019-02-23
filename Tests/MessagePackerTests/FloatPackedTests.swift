//
//  FloatPackedTests.swift
//  MessagePackerTests
//
//  Created by hirotaka on 2018/11/12.
//  Copyright © 2018 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class FloatPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFloat() {
        let input: Float = 3.14
        let output = Data([202, 64, 72, 245, 195])
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
