//
//  CustomkeyedCollection.swift
//  Tests
//
//  Created by Hirotaka Nishiyama on 2019/03/03.
//  Copyright © 2019年 hiro. All rights reserved.
//

import Foundation

struct CustomkeyedCollection {
    typealias CollectionType = [String: Int]

    private(set) var elements: CollectionType
}

extension CustomkeyedCollection: Collection {
    typealias Index = CollectionType.Index
    typealias Element = CollectionType.Element

    var startIndex: Index {
        return elements.startIndex
    }

    var endIndex: Index {
        return elements.endIndex
    }

    subscript(index: Index) -> Element {
        get {
            return elements[index]
        }
    }

    subscript(key: String) -> Int? {
        get { return elements[key] }
        set { elements[key] = newValue }
    }

    func index(after i: Index) -> Index {
        return elements.index(after: i)
    }
}

extension CustomkeyedCollection: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (String, Int)...) {
        self.elements = elements.reduce(into: [String: Int]()) { $0[$1.0] = $1.1 }
    }
}

extension CustomkeyedCollection: Codable {
    struct DictionaryCodingKey : CodingKey {
        internal let stringValue: String
        internal let intValue: Int?

        internal init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }

        internal init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DictionaryCodingKey.self)
        for (key, value) in self {
            let codingKey = DictionaryCodingKey(stringValue: key)!
            try container.encode(value, forKey: codingKey)
        }
    }

    init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: DictionaryCodingKey.self)
        for key in container.allKeys {
            let value = try container.decode(Value.self, forKey: key)
            self[key.stringValue] = value
        }
    }
}
