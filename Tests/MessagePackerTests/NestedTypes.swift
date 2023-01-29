//
//  NestedTypes.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2023/01/28.
//  Copyright © 2023年 hiro. All rights reserved.
//

struct NestedTypeEncodingAsFlattened: Equatable {
    var outerTypeProperty: String

    struct InnerType: Codable, Equatable {
        var innerTypeProperty: String
    }
    let innerType: InnerType
}

extension NestedTypeEncodingAsFlattened: Codable {
    enum CodingKeys: String, CodingKey {
        case outerTypeProperty
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.outerTypeProperty = try container.decode(String.self, forKey: .outerTypeProperty)

        self.innerType = try InnerType(from: decoder)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(outerTypeProperty, forKey: .outerTypeProperty)

        try innerType.encode(to: encoder)
    }
}

// MARK: -

struct NestedTypeEncodingAsFlattenedUnkeyed: Equatable {
    var outerTypeProperty: String

    struct InnerType: Equatable {
        var innerTypeProperty: String
    }
    let innerType: InnerType
}

extension NestedTypeEncodingAsFlattenedUnkeyed: Codable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.outerTypeProperty = try container.decode(String.self)

        self.innerType = try InnerType(from: decoder)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(outerTypeProperty)

        try innerType.encode(to: encoder)
    }
}

extension NestedTypeEncodingAsFlattenedUnkeyed.InnerType: Codable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.innerTypeProperty = try container.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(innerTypeProperty)
    }
}

// MARK: -

struct FlattenedTypeEncodingAsNested: Equatable {
    var outerTypeProperty: String
    var innerTypeProperty: String
}

extension FlattenedTypeEncodingAsNested: Codable {
    enum OuterTypeCodingKeys: String, CodingKey {
        case outerTypeProperty
        case innerType
    }

    enum InnerTypeCodingKeys: String, CodingKey {
        case innerTypeProperty
    }

    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterTypeCodingKeys.self)
        self.outerTypeProperty = try outerContainer.decode(String.self, forKey: .outerTypeProperty)

        let innerContainer = try outerContainer.nestedContainer(keyedBy: InnerTypeCodingKeys.self, forKey: .innerType)
        self.innerTypeProperty = try innerContainer.decode(String.self, forKey: .innerTypeProperty)
    }

    func encode(to encoder: Encoder) throws {
        var outerContainer = encoder.container(keyedBy: OuterTypeCodingKeys.self)
        try outerContainer.encode(outerTypeProperty, forKey: .outerTypeProperty)

        var innerContainer = outerContainer.nestedContainer(keyedBy: InnerTypeCodingKeys.self, forKey: .innerType)
        try innerContainer.encode(innerTypeProperty, forKey: .innerTypeProperty)
    }
}

// MARK: -

struct FlattenedTypeEncodingAsNestedUnkeyed: Equatable {
    var outerTypeProperty: String
    var innerTypeProperty: String
}

extension FlattenedTypeEncodingAsNestedUnkeyed: Codable {
    init(from decoder: Decoder) throws {
        var outerContainer = try decoder.unkeyedContainer()
        self.outerTypeProperty = try outerContainer.decode(String.self)

        var innerContainer = try outerContainer.nestedUnkeyedContainer()
        self.innerTypeProperty = try innerContainer.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var outerContainer = encoder.unkeyedContainer()
        try outerContainer.encode(outerTypeProperty)

        var innerContainer = outerContainer.nestedUnkeyedContainer()
        try innerContainer.encode(innerTypeProperty)
    }
}

// MARK: -

struct FlattenedTypeEncodingAsNestedWithInnerMessageUnkeyed: Equatable {
    var outerTypeProperty: String
    var innerTypeProperty: String
}

extension FlattenedTypeEncodingAsNestedWithInnerMessageUnkeyed: Codable {
    enum OuterTypeCodingKeys: String, CodingKey {
        case outerTypeProperty
        case innerType
    }

    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterTypeCodingKeys.self)
        self.outerTypeProperty = try outerContainer.decode(String.self, forKey: .outerTypeProperty)

        var innerContainer = try outerContainer.nestedUnkeyedContainer(forKey: .innerType)
        self.innerTypeProperty = try innerContainer.decode(String.self)
    }

    func encode(to encoder: Encoder) throws {
        var outerContainer = encoder.container(keyedBy: OuterTypeCodingKeys.self)
        try outerContainer.encode(outerTypeProperty, forKey: .outerTypeProperty)

        var innerContainer = outerContainer.nestedUnkeyedContainer(forKey: .innerType)
        try innerContainer.encode(innerTypeProperty)
    }
}

// MARK: -

struct FlattenedTypeEncodingAsNestedWithOuterMessageUnkeyed: Equatable {
    var outerTypeProperty: String
    var innerTypeProperty: String
}

extension FlattenedTypeEncodingAsNestedWithOuterMessageUnkeyed: Codable {
    enum InnerTypeCodingKeys: String, CodingKey {
        case innerTypeProperty
    }

    init(from decoder: Decoder) throws {
        var outerContainer = try decoder.unkeyedContainer()
        self.outerTypeProperty = try outerContainer.decode(String.self)

        let innerContainer = try outerContainer.nestedContainer(keyedBy: InnerTypeCodingKeys.self)
        self.innerTypeProperty = try innerContainer.decode(String.self, forKey: .innerTypeProperty)
    }

    func encode(to encoder: Encoder) throws {
        var outerContainer = encoder.unkeyedContainer()
        try outerContainer.encode(outerTypeProperty)

        var innerContainer = outerContainer.nestedContainer(keyedBy: InnerTypeCodingKeys.self)
        try innerContainer.encode(innerTypeProperty, forKey: .innerTypeProperty)
    }
}
