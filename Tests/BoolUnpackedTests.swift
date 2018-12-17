//
//  BoolUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/12.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class BoolUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFalse() {
        let input = Data([194])
        let output = false
        XCTAssertEqual(try decoder.decode(Bool.self, from: input), output)
    }

    func testTrue() {
        let input = Data([195])
        let output = true
        XCTAssertEqual(try decoder.decode(Bool.self, from: input), output)
    }
}
