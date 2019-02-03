//
//  NilUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class NilUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNil() {
        let input = Data([192])
        let output: Int? = nil
        XCTAssertEqual(try decoder.decode(Int?.self, from: input), output)
    }

    func testValue() {
        let input = Data([255])
        let output: Int? = -1
        XCTAssertEqual(try decoder.decode(Int?.self, from: input), output)
    }
}
