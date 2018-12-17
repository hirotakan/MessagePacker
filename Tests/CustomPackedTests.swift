//
//  CustomPackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/11.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

struct Article: Codable, Equatable {
    var title: String
    var body: String
    var author: Author
    var comments: [Comment]

//    init(title: String, body: String, author: Author, comments: [Comment] = []) {
//        self.title = title
//        self.body = body
//        self.author = author
//        self.comments = comments
//    }
}

struct Comment: Codable, Equatable {
    var text: String
}

struct Author: Codable, Equatable {
    var firstName: String
    var lastName: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
    }
}

typealias Mothor = String

// TODO: どこに定義する？
struct TestUser: Codable, Equatable {
    var id: Int
    var firstName: String
    var lastName: String
    var mother: Mothor?
    var friends: [TestUser]

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case mother
        case friends
    }

    enum SuperCodingKeys: String, CodingKey {
        case `testUser`
    }

    init(id: Int, firstName: String, lastName: String, mother: Mothor? = nil, friends: [TestUser] = []) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.mother = mother
        self.friends = friends
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(firstName, forKey: .firstName)
//        try container.encode(lastName, forKey: .lastName)
        let superEncoder = container.superEncoder()
//        let superEncoder = container.superEncoder(forKey: .firstName)
        var superContainer = superEncoder.container(keyedBy: CodingKeys.self)
        try superContainer.encode(id, forKey: .id)
        try superContainer.encode(firstName, forKey: .firstName)
        try superContainer.encode(lastName, forKey: .lastName)
        try superContainer.encode(mother, forKey: .mother)
        try superContainer.encode(friends, forKey: .friends)

//        var unkeyedContainer = encoder.unkeyedContainer()
//        let superEncoder = unkeyedContainer.superEncoder()
//        var superContainer = superEncoder.container(keyedBy: CodingKeys.self)
//        var superContainer = superEncoder.unkeyedContainer()
//        try superContainer.encode(firstName)
//        try superContainer.encode(lastName)
//        try superContainer.encode(friends)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.firstName = try container.decode(String.self, forKey: .firstName)
//        self.lastName = try container.decode(String.self, forKey: .lastName)
//        self.mother = try container.decode(Mothor.self, forKey: .mother)
//        self.friends = try container.decode(Array.self, forKey: .friends)
        let superContainer = try container.superDecoder().container(keyedBy: CodingKeys.self)
        self.id = try superContainer.decode(Int.self, forKey: .id)
        self.firstName = try superContainer.decode(String.self, forKey: .firstName)
        self.lastName = try superContainer.decode(String.self, forKey: .lastName)
        self.mother = try superContainer.decode(Mothor.self, forKey: .mother)
        self.friends = try superContainer.decode(Array.self, forKey: .friends)
    }
}

class Animal: Codable {
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

class Dog: Animal, Equatable {
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return lhs.legCount == rhs.legCount
            && lhs.name == rhs.name
            && lhs.color == rhs.color
    }

    var name: String
    var color: String

    private enum CodingKeys: String, CodingKey {
        case name
        case color
    }

    required init(legCount: Int, name: String, color: String = "黒") {
        self.name = name
        self.color = color
        super.init(legCount: legCount)
    }

    override func encode(to encoder: Encoder) throws {
        //        var container = encoder.container(keyedBy: CodingKeys.self)
        //        try container.encode(name, forKey: .name)
        //        let superEncoder = container.superEncoder()
        //        try super.encode(to: superEncoder)

//        var container = encoder.unkeyedContainer()
//        try container.encode(name)
//        let superEncoder = container.superEncoder()
//        try super.encode(to: superEncoder)

        //        var nestedContainer = container.nestedUnkeyedContainer(forKey: .name)
        //        try nestedContainer.encode(name)

        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .name)
        try nestedContainer.encode(name, forKey: .name)
        try nestedContainer.encode(color, forKey: .color)

//        var nestedContainer2 = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .color)
//        try nestedContainer2.encode(name, forKey: .name)
//        try nestedContainer2.encode(color, forKey: .color)

        var nestedContainer2 = container.nestedUnkeyedContainer(forKey: .color)
        try nestedContainer2.encode(name)
        try nestedContainer2.encode(color)

//        var nestedContainer3 = nestedContainer2.nestedContainer(keyedBy: CodingKeys.self, forKey: .name)

        var nestedContainer3 = nestedContainer2.nestedContainer(keyedBy: CodingKeys.self)
//
        try nestedContainer3.encode(name, forKey: .name)
        try nestedContainer3.encode(color, forKey: .color)

//        var nestedContainer3 = nestedContainer2.nestedUnkeyedContainer()

//        try nestedContainer3.encode(name)
//        try nestedContainer3.encode(color)

//        let superEncoder = container.superEncoder()
        let superEncoder = nestedContainer3.superEncoder()
        try super.encode(to: superEncoder)
    }

    required init(from decoder: Decoder) throws {
        //        let container = try decoder.container(keyedBy: CodingKeys.self)
        //        name = try container.decode(String.self, forKey: .name)
        //        let superDecoder = try container.superDecoder()
        //        try super.init(from: superDecoder)

//        var container = try decoder.unkeyedContainer()
//        name = try container.decode(String.self)
//        let superDecoder = try container.superDecoder()
//        try super.init(from: superDecoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name)

//        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .name)
//        name = try nestedContainer.decode(String.self, forKey: .name)
//        color = try nestedContainer.decode(String.self, forKey: .color)

        var nestedContainer = try container.nestedUnkeyedContainer(forKey: .color)
        name = try nestedContainer.decode(String.self)
        color = try nestedContainer.decode(String.self)

        let nestedContainer2 = try nestedContainer.nestedContainer(keyedBy: CodingKeys.self)
        name = try nestedContainer2.decode(String.self, forKey: .name)
        color = try nestedContainer2.decode(String.self, forKey: .color)

//        var nestedContainer2 = try nestedContainer.nestedUnkeyedContainer()
//        name = try nestedContainer2.decode(String.self)
//        color = try nestedContainer2.decode(String.self)

//        let superDecoder = try container.superDecoder()
        let superDecoder = try nestedContainer2.superDecoder()
        try super.init(from: superDecoder)
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

    func testCustom() {
//        let friend = TestUser(id: 2, firstName: "hello", lastName: "world")
//        let input = TestUser(id: 1, firstName: "hoge", lastName: "fuga", friends: [friend, friend])
        let input = Dog(legCount: 4, name: "マサル")
//        let output = Data([131, 162, 105, 100, 1, 169, 102, 105, 114, 115, 116, 78, 97, 109, 101, 164, 104, 111, 103, 101, 168, 108, 97, 115, 116, 78, 97, 109, 101, 164, 102, 117, 103, 97])
//        let output = Data([131, 162, 105, 100, 1, 170, 102, 105, 114, 115, 116, 95, 110, 97, 109, 101, 164, 104, 111, 103, 101, 169, 108, 97, 115, 116, 95, 110, 97, 109, 101, 164, 102, 117, 103, 97])
        print([UInt8](try! encoder.encode(input)))
//        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testCustom_() {
        let author = Author(firstName: "Haruki", lastName: "Murakami")
        let comment = Comment(text: "Nice!!")
        let input = Article(title: "1Q84", body: "======", author: author, comments: [comment, comment])
        let output = Data([132, 165, 116, 105, 116, 108, 101, 164, 49, 81, 56, 52, 164, 98, 111, 100, 121, 166, 61, 61, 61, 61, 61, 61, 166, 97, 117, 116, 104, 111, 114, 130, 170, 102, 105, 114, 115, 116, 95, 110, 97, 109, 101, 166, 72, 97, 114, 117, 107, 105, 169, 108, 97, 115, 116, 95, 110, 97, 109, 101, 168, 77, 117, 114, 97, 107, 97, 109, 105, 168, 99, 111, 109, 109, 101, 110, 116, 115, 146, 129, 164, 116, 101, 120, 116, 166, 78, 105, 99, 101, 33, 33, 129, 164, 116, 101, 120, 116, 166, 78, 105, 99, 101, 33, 33])
        print([UInt8](try! encoder.encode(input)))
        XCTAssertEqual(try encoder.encode(input), output)
    }

    func testCustom__() {
        let input = [1.1: [1,2,3], 5.1: [10, 20]]
        print([UInt8](try! encoder.encode(input)))
    }

    func testDate() {
        let input = Date(timeIntervalSince1970: 1542590303)
        let output = Data([214, 255, 91, 242, 15, 95])
        XCTAssertEqual(try encoder.encode(input), output)
    }
}
