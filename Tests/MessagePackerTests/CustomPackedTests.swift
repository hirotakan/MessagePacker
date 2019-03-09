//
//  CustomPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class Animal: Codable, Equatable {
    var legCount: Int

    private enum CodingKeys: String, CodingKey {
        case legCount
    }

    init(legCount: Int) {
        self.legCount = legCount
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(legCount, forKey: .legCount)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        legCount = try container.decode(Int.self, forKey: .legCount)
    }
}

extension Animal {
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        return lhs.legCount == rhs.legCount
    }
}

class Dog: Animal {
    var name: String

    private enum CodingKeys: String, CodingKey {
        case name
    }

    required init(legCount: Int, name: String) {
        self.name = name
        super.init(legCount: legCount)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
}

extension Dog {
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return lhs.legCount == rhs.legCount
            && lhs.name == rhs.name
    }
}

class CustomPackedTests: XCTestCase {
    let encoder = MessagePackEncoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCustomSubClass() {
        let input = Dog(legCount: 4, name: "マサル")
        let output = Data([130, 164, 110, 97, 109, 101, 169, 227, 131, 158, 227, 130, 181, 227, 131, 171, 165, 115, 117, 112, 101, 114, 129, 168, 108, 101, 103, 67, 111, 117, 110, 116, 4])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testDate() {
        let input = Date(timeIntervalSince1970: 1542590303)
        let output = Data([214, 255, 91, 242, 15, 95])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testURL() {
        let input = URL(string: "https://www.google.co.jp/")!
        let output = Data([185, 104, 116, 116, 112, 115, 58, 47, 47, 119, 119, 119, 46, 103, 111, 111, 103, 108, 101, 46, 99, 111, 46, 106, 112, 47])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testCustomUnkeyedCollection() {
        let input: CustomUnkeyedCollection = [1, 2000, 23791724]
        let output = Data([147, 1, 205, 7, 208, 206, 1, 107, 8, 108])
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testCustomkeyedCollection() {
        let input: CustomkeyedCollection = ["a": 1, "b": 2000, "c": 23791724]
        let output = Data([131, 161, 98, 205, 7, 208, 161, 99, 206, 1, 107, 8, 108, 161, 97, 1])

        do {
            let result = try encoder.encode(input)
            let dic = try (0..<input.count)
                .reduce(into: (dic: [Data : Data](), index: 1)) { args, _ in
                    let key = try result
                        .subdata(startIndex: args.index)
                        .firstMessagePackeValue()
                    let value = try result
                        .subdata(startIndex: args.index + key.count)
                        .firstMessagePackeValue()
                    args.dic[key] = value
                    args.index += (key.count + value.count)
                }.dic

            XCTAssertEqual(result.count, output.count)
            XCTAssertEqual(result.first, output.first)
            XCTAssertEqual(dic[Data([161, 97])], Data([1]))
            XCTAssertEqual(dic[Data([161, 98])], Data([205, 7, 208]))
            XCTAssertEqual(dic[Data([161, 99])], Data([206, 1, 107, 8, 108]))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
