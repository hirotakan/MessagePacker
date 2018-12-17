//
//  CustomUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class CustomUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCustom() {
//        let input = Data([131, 169, 102, 105, 114, 115, 116, 78, 97, 109, 101, 164, 104, 111, 103, 101, 168, 108, 97, 115, 116, 78, 97, 109, 101, 164, 102, 117, 103, 97, 162, 105, 100, 1])
//        let input = Data([131, 162, 105, 100, 1, 170, 102, 105, 114, 115, 116, 95, 110, 97, 109, 101, 164, 104, 111, 103, 101, 169, 108, 97, 115, 116, 95, 110, 97, 109, 101, 164, 102, 117, 103, 97])
//        let input = Data([131, 165, 115, 117, 112, 101, 114, 129, 168, 108, 101, 103, 67, 111, 117, 110, 116, 4, 165, 99, 111, 108, 111, 114, 147, 169, 227, 131, 158, 227, 130, 181, 227, 131, 171, 163, 233, 187, 146, 146, 169, 227, 131, 158, 227, 130, 181, 227, 131, 171, 163, 233, 187, 146, 164, 110, 97, 109, 101, 130, 164, 110, 97, 109, 101, 169, 227, 131, 158, 227, 130, 181, 227, 131, 171, 165, 99, 111, 108, 111, 114, 163, 233, 187, 146])
        let input = Data([130, 165, 99, 111, 108, 111, 114, 147, 169, 227, 131, 158, 227, 130, 181, 227, 131, 171, 163, 233, 187, 146, 131, 164, 110, 97, 109, 101, 169, 227, 131, 158, 227, 130, 181, 227, 131, 171, 165, 99, 111, 108, 111, 114, 163, 233, 187, 146, 165, 115, 117, 112, 101, 114, 129, 168, 108, 101, 103, 67, 111, 117, 110, 116, 4, 164, 110, 97, 109, 101, 130, 164, 110, 97, 109, 101, 169, 227, 131, 158, 227, 130, 181, 227, 131, 171, 165, 99, 111, 108, 111, 114, 163, 233, 187, 146])
        let output = Dog(legCount: 4, name: "マサル")
//        print((try? decoder.decode(Dog.self, from: input))?.name)
        XCTAssertEqual(try decoder.decode(Dog.self, from: input), output)
    }

    func testCustom_() {
        let input = Data([132, 165, 116, 105, 116, 108, 101, 164, 49, 81, 56, 52, 164, 98, 111, 100, 121, 166, 61, 61, 61, 61, 61, 61, 166, 97, 117, 116, 104, 111, 114, 130, 170, 102, 105, 114, 115, 116, 95, 110, 97, 109, 101, 166, 72, 97, 114, 117, 107, 105, 169, 108, 97, 115, 116, 95, 110, 97, 109, 101, 168, 77, 117, 114, 97, 107, 97, 109, 105, 168, 99, 111, 109, 109, 101, 110, 116, 115, 146, 129, 164, 116, 101, 120, 116, 166, 78, 105, 99, 101, 33, 33, 129, 164, 116, 101, 120, 116, 166, 78, 105, 99, 101, 33, 33])
        let author = Author(firstName: "Haruki", lastName: "Murakami")
        let comment = Comment(text: "Nice!!")
        let output = Article(title: "1Q84", body: "======", author: author, comments: [comment, comment])
        XCTAssertEqual(try decoder.decode(Article.self, from: input), output)
    }

    func testCustom__() {
        let input = Data([148, 203, 64, 20, 102, 102, 102, 102, 102, 102, 146, 10, 20, 203, 63, 241, 153, 153, 153, 153, 153, 154, 147, 1, 2, 3])
        print(try! decoder.decode(Dictionary<Double, Array<Int>>.self, from: input))
    }

    func testDate() {
        let input = Data([214, 255, 91, 242, 15, 95])
        let output = Date(timeIntervalSince1970: 1542590303)
        XCTAssertEqual(try decoder.decode(Date.self, from: input), output)
    }
}
