//
//  MessagePackDecoder.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/10/08.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

open class MessagePackDecoder: Decoder {
    public var codingPath: [CodingKey] = []
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    private var storage = MessagePackStorage()

    public init() {}

    public init(referencing: Data, codingPath: [CodingKey] = []) {
        storage.push(container: referencing)
        self.codingPath = codingPath
    }

    public func container<Key: CodingKey>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        do {
            let container = try lastContainer(KeyedDecodingContainer<Key>.self)
            let value = try MessagePackType.MapType.split(for: container)
            return KeyedDecodingContainer(KeyedContainer<Key>(referencing: self, container: value))
        } catch let error as MessagePackError {
            throw error.asDecodingError([String: Any].self, codingPath: codingPath)
        } catch {
            throw error
        }
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        do {
            let container = try lastContainer(UnkeyedDecodingContainer.self)
            let value = try MessagePackType.ArrayType.split(for: container)
            return UnkeyedContainer(referencing: self, container: value)
        } catch let error as MessagePackError {
            throw error.asDecodingError([Any].self, codingPath: codingPath)
        } catch {
            throw error
        }
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        do {
            let container = try lastContainer(SingleValueDecodingContainer.self)
            return SingleValueContainer(referencing: self, container: container)
        } catch let error as MessagePackError {
            throw error.asDecodingError([Any].self, codingPath: codingPath)
        } catch {
            throw error
        }
    }

    open func decode<T : Decodable>(_ type: T.Type, from container: Data) throws -> T {
        return try unbox(container, as: type)
    }

    private func lastContainer<T>(_ type: T.Type) throws -> Data {
        guard let value = storage.last else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot get \(type) decoding container -- found null value instead.")
            throw DecodingError.valueNotFound(type.self, context)
        }
        return value
    }
}

private extension MessagePackDecoder {
    func unboxNil(_ value: Data) -> Bool {
        return value.first.map { $0 == MessagePackType.NilType.firstByte } ?? false
    }

    func unboxURL(_ value: Data) throws -> URL {
        let urlString = try String.unpack(for: value)
        guard let url = URL(string: urlString) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Invalid URL string."
                )
            )
        }
        return url
    }

    func unboxMessagePack<T: MessagePackable>(_ value: Data, as type: T.Type) throws -> T where T.T == T {
        do {
            return try type.unpack(for: value)
        } catch let error as MessagePackError {
            throw error.asDecodingError([Any].self, codingPath: codingPath)
        } catch {
            throw error
        }
    }

    func unboxInteger<T: BinaryInteger & MessagePackable>(_ value: Data, as type: T.Type) throws -> T where T.T == T {
        if let firstByte = value.first,
            let _ = try? MessagePackType.UnsignedIntegerType(firstByte) {
            return T(try unboxMessagePack(value, as: UInt64.self))
        } else {
            return try unboxMessagePack(value, as: type)
        }
    }

    func unbox<T: Decodable>(_ value: Data, as type: T.Type) throws -> T {
        storage.push(container: value)
        defer { _ = storage.popContainer() }

        switch T.self {
        case let type where type == Data.self || type == NSData.self:
            return try unboxMessagePack(value, as: Data.self) as! T
        case let type where type == Date.self || type == NSDate.self:
            return try unboxMessagePack(value, as: Date.self) as! T
        case let type where type == URL.self || type == NSURL.self:
            return try unboxURL(value) as! T
        default:
            return try T(from: self)
        }
    }
}

extension MessagePackDecoder {
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        private let decoder: MessagePackDecoder
        private(set) var codingPath: [CodingKey]
        private(set) var allKeys: [Key]
        private var container: [String: Data] = [:]

        init(referencing decoder: MessagePackDecoder, container: [String: Data]) {
            self.decoder = decoder
            self.codingPath = decoder.codingPath
            self.allKeys = container.keys.compactMap { Key(stringValue: $0) }
            self.container = container
        }

        func contains(_ key: Key) -> Bool {
            return container[key.stringValue] != nil
        }

        func findEntry(by key: CodingKey) throws -> Data {
            guard let entry = self.container[key.stringValue] else {
                let context = DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\").")
                throw DecodingError.keyNotFound(key, context)
            }
            return entry
        }

        func decode<T: MessagePackable>(as type: T.Type, forKey key: Key) throws -> T where T.T == T {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            let entry = try findEntry(by: key)
            return try decoder.unboxMessagePack(entry, as: type)
        }

        func decode<T: BinaryInteger & MessagePackable>(as type: T.Type, forKey key: Key) throws -> T where T.T == T {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            let entry = try findEntry(by: key)
            return try decoder.unboxInteger(entry, as: type)
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            return decoder.unboxNil(try findEntry(by: key))
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            return try decode(as: type, forKey: key)
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            return try decode(as: type, forKey: key)
        }

        func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }
            let entry = try findEntry(by: key)
            return try decoder.unbox(entry, as: type)
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }

            do {
                let entry = try findEntry(by: key)
                let container = try MessagePackType.MapType.split(for: entry)
                return KeyedDecodingContainer(KeyedContainer<NestedKey>(referencing: decoder, container: container))
            } catch let error as MessagePackError {
                throw error.asDecodingError([Any].self, codingPath: codingPath)
            } catch {
                throw error
            }
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }

            do {
                let entry = try findEntry(by: key)
                let container = try MessagePackType.ArrayType.split(for: entry)
                return UnkeyedContainer(referencing: decoder, container: container)
            } catch let error as MessagePackError {
                throw error.asDecodingError([Any].self, codingPath: codingPath)
            } catch {
                throw error
            }
        }

        func _superDecoder(forKey key: CodingKey) throws -> Decoder {
            decoder.codingPath.append(key)
            defer { decoder.codingPath.removeLast() }

            let entry = try findEntry(by: key)
            return MessagePackDecoder(referencing: entry, codingPath: decoder.codingPath)
        }

        func superDecoder() throws -> Decoder {
            return try _superDecoder(forKey: MessagePackKey.super)
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            return try _superDecoder(forKey: key)
        }

    }

    struct UnkeyedContainer: UnkeyedDecodingContainer {
        private let decoder: MessagePackDecoder
        private(set) var codingPath: [CodingKey]
        private(set) var count: Int?
        private var container: [Data]

        var isAtEnd: Bool {
            return currentIndex >= count!
        }

        var currentCodingPath: [CodingKey] {
            decoder.codingPath.append(MessagePackKey(index: currentIndex))
            return decoder.codingPath
        }

        private(set) var currentIndex = 0

        init(referencing decoder: MessagePackDecoder, container: [Data]) {
            self.decoder = decoder
            self.codingPath = decoder.codingPath
            self.count = container.count
            self.container = container
        }

        func validateIndex<T>(_ type: T.Type) throws {
            guard isAtEnd else { return }

            let context = DecodingError.Context(codingPath: self.currentCodingPath, debugDescription: "Unkeyed container is at end.")
            throw DecodingError.valueNotFound(T.self, context)
        }

        mutating func decode<T: MessagePackable>(as type: T.Type) throws -> T where T.T == T {
            try validateIndex(type)

            decoder.codingPath.append(MessagePackKey(index: currentIndex))
            defer { decoder.codingPath.removeLast() }

            let value = container[currentIndex]
            currentIndex += 1

            return try decoder.unboxMessagePack(value, as: type)
        }

        mutating func decode<T: BinaryInteger & MessagePackable>(as type: T.Type) throws -> T where T.T == T {
            try validateIndex(type)

            decoder.codingPath.append(MessagePackKey(index: currentIndex))
            defer { decoder.codingPath.removeLast() }

            let value = container[currentIndex]
            currentIndex += 1

            return try decoder.unboxInteger(value, as: type)
        }

        mutating func decodeNil() throws -> Bool {
            try validateIndex(Data?.self)
            return decoder.unboxNil(container[currentIndex])
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            return try decode(as: type)
        }

        mutating func decode(_ type: Int.Type) throws -> Int {
            return try decode(as: type)
        }

        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            return try decode(as: type)
        }

        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            return try decode(as: type)
        }

        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            return try decode(as: type)
        }

        mutating func decode(_ type: Int64.Type) throws -> Int64 {
            return try decode(as: type)
        }

        mutating func decode(_ type: UInt.Type) throws -> UInt {
            return try decode(as: type)
        }

        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try decode(as: type)
        }

        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try decode(as: type)
        }

        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try decode(as: type)
        }

        mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try decode(as: type)
        }

        mutating func decode(_ type: Float.Type) throws -> Float {
            return try decode(as: type)
        }

        mutating func decode(_ type: Double.Type) throws -> Double {
            return try decode(as: type)
        }

        mutating func decode(_ type: String.Type) throws -> String {
            return try decode(as: type)
        }

        mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
            try validateIndex(type)

            decoder.codingPath.append(MessagePackKey(index: currentIndex))
            defer { decoder.codingPath.removeLast() }

            let value = container[currentIndex]
            currentIndex += 1

            return try decoder.unbox(value, as: type)
        }

        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            decoder.codingPath.append(MessagePackKey(index: currentIndex))
            defer { decoder.codingPath.removeLast() }

            do {
                try validateIndex(UnkeyedContainer.self)

                let value = self.container[currentIndex]
                let container = try MessagePackType.MapType.split(for: value)

                currentIndex += 1

                return KeyedDecodingContainer(KeyedContainer<NestedKey>(referencing: decoder, container: container))
            } catch let error as MessagePackError {
                throw error.asDecodingError([Any].self, codingPath: codingPath)
            } catch {
                throw error
            }
        }

        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            decoder.codingPath.append(MessagePackKey(index: currentIndex))
            defer { decoder.codingPath.removeLast() }

            do {
                try validateIndex(UnkeyedContainer.self)

                let value = self.container[currentIndex]
                let container = try MessagePackType.ArrayType.split(for: value)

                currentIndex += 1

                return UnkeyedContainer(referencing: decoder, container: container)
            } catch let error as MessagePackError {
                throw error.asDecodingError([Any].self, codingPath: codingPath)
            } catch {
                throw error
            }
        }

        mutating func superDecoder() throws -> Decoder {
            decoder.codingPath.append(MessagePackKey(index: currentIndex))
            defer { decoder.codingPath.removeLast() }

            try validateIndex(UnkeyedContainer.self)

            let value = self.container[currentIndex]
            currentIndex += 1

            return MessagePackDecoder(referencing: value, codingPath: decoder.codingPath)
        }
    }

    struct SingleValueContainer: SingleValueDecodingContainer {
        private var decoder: MessagePackDecoder
        private(set) var codingPath: [CodingKey]
        private let container: Data

        init(referencing decoder: MessagePackDecoder, container: Data) {
            self.decoder = decoder
            self.codingPath = decoder.codingPath
            self.container = container
        }

        func decode<T: MessagePackable>(as type: T.Type) throws -> T where T.T == T {
            return try decoder.unboxMessagePack(container, as: type)
        }

        func decode<T: BinaryInteger & MessagePackable>(as type: T.Type) throws -> T where T.T == T {
            return try decoder.unboxInteger(container, as: type)
        }

        func decodeNil() -> Bool {
            return decoder.unboxNil(container)
        }

        func decode(_ type: Bool.Type) throws -> Bool {
            return try decode(as: type)
        }

        func decode(_ type: Int.Type) throws -> Int {
            return try decode(as: type)
        }

        func decode(_ type: Int8.Type) throws -> Int8 {
            return try decode(as: type)
        }

        func decode(_ type: Int16.Type) throws -> Int16 {
            return try decode(as: type)
        }

        func decode(_ type: Int32.Type) throws -> Int32 {
            return try decode(as: type)
        }

        func decode(_ type: Int64.Type) throws -> Int64 {
            return try decode(as: type)
        }

        func decode(_ type: UInt.Type) throws -> UInt {
            return try decode(as: type)
        }

        func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try decode(as: type)
        }

        func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try decode(as: type)
        }

        func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try decode(as: type)
        }

        func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try decode(as: type)
        }

        func decode(_ type: Float.Type) throws -> Float {
            return try decode(as: type)
        }

        func decode(_ type: Double.Type) throws -> Double {
            return try decode(as: type)
        }

        func decode(_ type: String.Type) throws -> String {
            return try decode(as: type)
        }

        func decode<T: Decodable>(_ type: T.Type) throws -> T {
            return try decoder.unbox(container, as: type)
        }
    }
}
