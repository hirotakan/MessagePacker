//
//  MessagePackEncoder.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/10/07.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

open class MessagePackEncoder: Encoder {
    public var codingPath: [CodingKey] = []
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    fileprivate var storage = MessagePackStorage()

    public init() {}

    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(KeyedContainer<Key>(referencing: self, codingPath: codingPath))
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContanier(referencing: self, codingPath: codingPath)
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        return SingleValueContanier(referencing: self, codingPath: codingPath)
    }

    open func encode<T: Encodable>(_ value: T) throws -> Data {
        return try box(value)
    }
}

private extension MessagePackEncoder {
    func boxNil() -> Data {
        return Data([MessagePackType.NilType.firstByte])
    }

    func boxInteger<T: BinaryInteger>(_ value: T) -> Data {
        return value > 0 ? UInt64(value).pack() : Int64(value).pack()
    }

    func boxMessagePack<T: MessagePackable>(_ value: T) -> Data {
        return value.pack()
    }

    func box<T : Encodable>(_ value: T) throws -> Data {
        switch T.self {
        case let type where type == Data.self || type == NSData.self:
            return boxMessagePack(value as! Data)
        case let type where type == Date.self || type == NSDate.self:
            return boxMessagePack(value as! Date)
        case let type where type == URL.self || type == NSURL.self:
            return boxMessagePack((value as! URL).absoluteString)
        default:
            try value.encode(to: self)
            return storage.popContainer()
        }
    }
}

extension MessagePackEncoder {
    class KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        private let encoder: MessagePackEncoder
        private(set) var codingPath: [CodingKey]
        fileprivate var count = 0
        fileprivate var packedData = Data()

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey]) {
            self.encoder = encoder
            self.codingPath = codingPath
        }

        fileprivate func add(_ value: Data, forKey key: CodingKey) {
            let key = encoder.boxMessagePack(key.stringValue)
            self.packedData += key + value
            count += 1
        }

        func encodeNil(forKey key: Key) throws {
            add(encoder.boxNil(), forKey: key)
        }

        func encode(_ value: Bool, forKey key: Key) throws {
            add(encoder.boxMessagePack(value), forKey: key)
        }

        func encode(_ value: Int, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: Int8, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: Int16, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: Int32, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: Int64, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: UInt, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: UInt8, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: UInt16, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: UInt32, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: UInt64, forKey key: Key) throws {
            add(encoder.boxInteger(value), forKey: key)
        }

        func encode(_ value: Float, forKey key: Key) throws {
            add(encoder.boxMessagePack(value), forKey: key)
        }

        func encode(_ value: Double, forKey key: Key) throws {
            add(encoder.boxMessagePack(value), forKey: key)
        }

        func encode(_ value: String, forKey key: Key) throws {
            add(encoder.boxMessagePack(value), forKey: key)
        }

        func encode<T: MessagePackable>(_ value: T, forKey key: Key) throws {
            add(encoder.boxMessagePack(value), forKey: key)
        }

        func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
            encoder.codingPath.append(key)
            defer { encoder.codingPath.removeLast() }
            add(try encoder.box(value), forKey: key)
        }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
            codingPath.append(key)
            defer { codingPath.removeLast() }
            return KeyedEncodingContainer(NestedKeyedContainer<NestedKey, Key>(referencing: encoder, codingPath: codingPath, container: self, key: key))
        }

        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            codingPath.append(key)
            defer { codingPath.removeLast() }
            return NestedUnkeyedContainer(referencing: encoder, codingPath: codingPath, container: self, key: key)
        }

        func superEncoder() -> Encoder {
            return MessagePackReferencingKeyedEncoder(container: self, key: MessagePackKey.super)
        }

        func superEncoder(forKey key: Key) -> Encoder {
            return MessagePackReferencingKeyedEncoder(container: self, key: key)
        }

        deinit {
            let container = MessagePackType.MapType.pack(count: count, value: packedData)
            encoder.storage.push(container: container)
        }
    }

    class UnkeyedContanier: UnkeyedEncodingContainer {
        private let encoder: MessagePackEncoder
        private(set) var codingPath: [CodingKey]
        fileprivate(set) var count = 0
        fileprivate var packedData = Data()

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey]) {
            self.encoder = encoder
            self.codingPath = codingPath
        }

        fileprivate func insert(_ value: Data, at index: Int) {
            packedData.insert(contentsOf: value, at: index)
            count += 1
        }

        private func add(_ value: Data) {
            packedData += value
            count += 1
        }

        func encodeNil() throws {
            add(encoder.boxNil())
        }

        func encode(_ value: Bool) throws {
            add(encoder.boxMessagePack(value))
        }

        func encode(_ value: Int) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: Int8) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: Int16) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: Int32) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: Int64) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: UInt) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: UInt8) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: UInt16) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: UInt32) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: UInt64) throws {
            add(encoder.boxInteger(value))
        }

        func encode(_ value: Float) throws {
            add(encoder.boxMessagePack(value))
        }

        func encode(_ value: Double) throws {
            add(encoder.boxMessagePack(value))
        }

        func encode(_ value: String) throws {
            add(encoder.boxMessagePack(value))
        }

        func encode<T: MessagePackable>(_ value: T) throws {
            add(encoder.boxMessagePack(value))
        }

        func encode<T: Encodable>(_ value: T) throws {
            encoder.codingPath.append(MessagePackKey(index: count))
            defer { encoder.codingPath.removeLast() }
            add(try encoder.box(value))
        }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            codingPath.append(MessagePackKey(index: count))
            defer { codingPath.removeLast() }
            return KeyedEncodingContainer(NestedKeyedContainer<NestedKey, MessagePackKey>(referencing: encoder, codingPath: codingPath, container: self, index: packedData.endIndex))
        }

        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            codingPath.append(MessagePackKey(index: count))
            defer { codingPath.removeLast() }
            return NestedUnkeyedContainer<MessagePackKey>(referencing: encoder, codingPath: codingPath, container: self, index: packedData.endIndex)
        }

        func superEncoder() -> Encoder {
            return MessagePackReferencingUnkeyedEncoder(container: self, index: packedData.endIndex)
        }

        deinit {
            let container = MessagePackType.ArrayType.pack(count: count, value: packedData)
            encoder.storage.push(container: container)
        }
    }

    class SingleValueContanier: SingleValueEncodingContainer {
        private let encoder: MessagePackEncoder
        private(set) var codingPath: [CodingKey]

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey]) {
            self.encoder = encoder
            self.codingPath = codingPath
        }

        private func push(_ value: Data) {
            encoder.storage.push(container: value)
        }

        func encodeNil() throws {
            push(encoder.boxNil())
        }

        func encode(_ value: Bool) throws {
            push(encoder.boxMessagePack(value))
        }

        func encode(_ value: Int) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: Int8) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: Int16) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: Int32) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: Int64) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: UInt) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: UInt8) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: UInt16) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: UInt32) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: UInt64) throws {
            push(encoder.boxInteger(value))
        }

        func encode(_ value: Float) throws {
            push(encoder.boxMessagePack(value))
        }

        func encode(_ value: Double) throws {
            push(encoder.boxMessagePack(value))
        }

        func encode(_ value: String) throws {
            push(encoder.boxMessagePack(value))
        }

        func encode<T: Encodable>(_ value: T) throws {
            push(try encoder.box(value))
        }

        func encode<T: MessagePackable>(_ value: T) throws {
            push(encoder.boxMessagePack(value))
        }
    }

    class NestedKeyedContainer<NestedKey: CodingKey, Key: CodingKey>: KeyedContainer<NestedKey> {
        private enum Reference {
            case array(UnkeyedContanier, Int)
            case dictionary(KeyedContainer<Key>, CodingKey)
        }

        private let reference: Reference

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey], container: KeyedContainer<Key>, key: CodingKey) {
            reference = .dictionary(container, key)
            super.init(referencing: encoder, codingPath: codingPath)
        }

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey], container: UnkeyedContanier, index: Int) {
            reference = .array(container, index)
            super.init(referencing: encoder, codingPath: codingPath)
        }

        deinit {
            let value = MessagePackType.MapType.pack(count: count, value: packedData)
            switch reference {
            case let .array(container, index):
                container.insert(value, at: index)
            case let .dictionary(container, key):
                container.add(value, forKey: key)
            }
        }
    }

    class NestedUnkeyedContainer<Key: CodingKey>: UnkeyedContanier {
        private enum Reference {
            case array(UnkeyedContanier, Int)
            case dictionary(KeyedContainer<Key>, CodingKey)
        }

        private let reference: Reference

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey], container: KeyedContainer<Key>, key: CodingKey) {
            reference = .dictionary(container, key)
            super.init(referencing: encoder, codingPath: codingPath)
        }

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey], container: UnkeyedContanier, index: Int) {
            reference = .array(container, index)
            super.init(referencing: encoder, codingPath: codingPath)
        }

        deinit {
            let value = MessagePackType.ArrayType.pack(count: count, value: packedData)
            switch reference {
            case let .array(container, index):
                container.insert(value, at: index)
            case let .dictionary(container, key):
                container.add(value, forKey: key)
            }
        }
    }

    class MessagePackReferencingKeyedEncoder<Key: CodingKey>: MessagePackEncoder {
        private let container: KeyedContainer<Key>
        private let key: CodingKey

        init(container: KeyedContainer<Key>, key: CodingKey) {
            self.container = container
            self.key = key
            super.init()
        }

        deinit {
            container.add(storage.popContainer(), forKey: key)
        }
    }

    class MessagePackReferencingUnkeyedEncoder: MessagePackEncoder {
        private let container: UnkeyedContanier
        private let index: Int

        init(container: UnkeyedContanier, index: Int) {
            self.container = container
            self.index = index
            super.init()
        }

        deinit {
            container.insert(storage.popContainer(), at: index)
        }
    }
}
