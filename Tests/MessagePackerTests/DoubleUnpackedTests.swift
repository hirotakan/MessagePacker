//
//  DoubleUnpackedTests.swift
//  MessagePackerTests
//
//  Created by hirotaka on 2018/11/12.
//  Copyright © 2018 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class DoubleUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDouble() {
        let input = Data([203, 64, 9, 30, 184, 81, 235, 133, 31])
        let output = 3.14
        XCTAssertEqual(try decoder.decode(Double.self, from: input), output)
    }

    func testMismatchedType() {
        let input = Data([207, 255, 255, 255, 255, 255, 255, 255, 255])
        XCTAssertThrowsError(try decoder.decode(Double.self, from: input))
    }
}
