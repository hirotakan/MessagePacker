//
//  BinaryPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/13.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class BinaryPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBinary8() {
        let input = Data([0, 1, 2, 3, 4])
        let output = Data([196, 5, 0, 1, 2, 3, 4])
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
