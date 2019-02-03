//
//  FloatUnpackedTests.swift
//  MessagePackerTests
//
//  Created by hirotaka on 2018/11/12.
//  Copyright © 2018 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class FloatUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFloat() {
        let input = Data([202, 64, 72, 245, 195])
        let output: Float = 3.14
        XCTAssertEqual(try decoder.decode(Float.self, from: input), output)
    }
}
