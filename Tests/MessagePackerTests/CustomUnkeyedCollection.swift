//
//  CustomUnkeyedCollection.swift
//  Tests
//
//  Created by Hirotaka Nishiyama on 2019/03/03.
//  Copyright © 2019年 hiro. All rights reserved.
//

import Foundation

struct CustomUnkeyedCollection: Equatable {
    typealias CollectionType = [Int]

    private(set) var elements: CollectionType
}

extension CustomUnkeyedCollection: Collection {
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

    func index(after i: Index) -> Index {
        return elements.index(after: i)
    }

    mutating func append(_ newElement: CollectionType.Element) {
        elements.append(newElement)
    }
}

extension CustomUnkeyedCollection: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.elements = elements
    }
}

extension CustomUnkeyedCollection: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try container.encode(element)
        }
    }

    init(from decoder: Decoder) throws {
        self.init()

        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.append(element)
        }
    }
}
