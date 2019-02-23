//
//  MapUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class MapUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNilMap() {
        let input = Data([129, 161, 49, 192])
        let output: [String: Double?] = ["1": nil]

        XCTAssertEqual(try decoder.decode(Dictionary.self, from: input), output)
    }

    func testFixMap() {
        let input = Data([130, 161, 50, 203, 64, 1, 153, 153, 153, 153, 153, 154, 161, 49, 203, 63, 241, 153, 153, 153, 153, 153, 154])
        let output: [String: Double] = ["1": 1.1, "2": 2.2]

        do {
            let result: [String: Double] = try decoder.decode(Dictionary.self, from: input)
            result.forEach { XCTAssertEqual(output[$0.key], $0.value) }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test2DimensionalMap() {
        let input = Data([129, 161, 97, 129, 161, 98, 2])
        let output = ["a": ["b": 2]]

        XCTAssertEqual(try decoder.decode(Dictionary.self, from: input), output)
    }
}
