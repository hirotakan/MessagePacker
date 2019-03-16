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
        return KeyedEncodingContainer(KeyedContainer<Key>(referencing: self, codingPath: codingPath) { [weak self] in
            guard let `self` = self else { return }
            self.storage.push(container: $0)
        })
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContainer(referencing: self, codingPath: codingPath) { [weak self] in
            guard let `self` = self else { return }
            self.storage.push(container: $0)
        }
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        return SingleValueContainer(referencing: self, codingPath: codingPath)
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
        case let type where type == Bool.self:
            return boxMessagePack(value as! Bool)
        case let type where type == Int.self:
            return boxInteger(value as! Int)
        case let type where type == Int8.self:
            return boxInteger(value as! Int8)
        case let type where type == Int16.self:
            return boxInteger(value as! Int16)
        case let type where type == Int32.self:
            return boxInteger(value as! Int32)
        case let type where type == Int64.self:
            return boxInteger(value as! Int64)
        case let type where type == UInt.self:
            return boxInteger(value as! UInt)
        case let type where type == UInt8.self:
            return boxInteger(value as! UInt8)
        case let type where type == UInt16.self:
            return boxInteger(value as! UInt16)
        case let type where type == UInt32.self:
            return boxInteger(value as! UInt32)
        case let type where type == UInt64.self:
            return boxInteger(value as! UInt64)
        case let type where type == Float.self:
            return boxMessagePack(value as! Float)
        case let type where type == Double.self:
            return boxMessagePack(value as! Double)
        case let type where type == String.self:
            return boxMessagePack(value as! String)
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
        private var count = 0
        private var packedData = Data()
        private let completion: (Data) -> ()

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey], completion: @escaping (Data) -> ()) {
            self.encoder = encoder
            self.codingPath = codingPath
            self.completion = completion
        }

        fileprivate func add(_ value: Data, forKey key: CodingKey) {
            let key = encoder.boxMessagePack(key.stringValue)
            self.packedData.append(key)
            self.packedData.append(value)
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
            return KeyedEncodingContainer(KeyedContainer<NestedKey>(referencing: encoder, codingPath: codingPath) { [weak self] in
                guard let `self` = self else { return }
                self.add($0, forKey: key)
            })
        }

        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            codingPath.append(key)
            defer { codingPath.removeLast() }
            return UnkeyedContainer(referencing: encoder, codingPath: codingPath) { [weak self] in
                guard let `self` = self else { return }
                self.add($0, forKey: key)
            }
        }

        func superEncoder() -> Encoder {
            return MessagePackReferencingKeyedEncoder(container: self, key: MessagePackKey.super)
        }

        func superEncoder(forKey key: Key) -> Encoder {
            return MessagePackReferencingKeyedEncoder(container: self, key: key)
        }

        deinit {
            let value = MessagePackType.MapType.pack(count: count, value: packedData)
            completion(value)
        }
    }

    final class UnkeyedContainer: UnkeyedEncodingContainer {
        private let encoder: MessagePackEncoder
        private(set) var codingPath: [CodingKey]
        private(set) var count = 0
        private var packedData = Data()
        private let completion: (Data) -> ()

        init(referencing encoder: MessagePackEncoder, codingPath: [CodingKey], completion: @escaping (Data) -> ()) {
            self.encoder = encoder
            self.codingPath = codingPath
            self.completion = completion
        }

        fileprivate func insert(_ value: Data, at index: Int) {
            packedData.insert(contentsOf: value, at: index)
            count += 1
        }

        private func add(_ value: Data) {
            packedData.append(value)
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
            return KeyedEncodingContainer(KeyedContainer<NestedKey>(referencing: encoder, codingPath: codingPath) { [weak self] in
                guard let `self` = self else { return }
                self.insert($0, at: self.packedData.endIndex)
            })
        }

        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            codingPath.append(MessagePackKey(index: count))
            defer { codingPath.removeLast() }
            return UnkeyedContainer(referencing: encoder, codingPath: codingPath) { [weak self] in
                guard let `self` = self else { return }
                self.insert($0, at: self.packedData.endIndex)
            }
        }

        func superEncoder() -> Encoder {
            return MessagePackReferencingUnkeyedEncoder(container: self, index: packedData.endIndex)
        }

        deinit {
            let value = MessagePackType.ArrayType.pack(count: count, value: packedData)
            completion(value)
        }
    }

    struct SingleValueContainer: SingleValueEncodingContainer {
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

        func encode<T: MessagePackable>(from value: T) throws {
            push(encoder.boxMessagePack(value))
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
        private let container: UnkeyedContainer
        private let index: Int

        init(container: UnkeyedContainer, index: Int) {
            self.container = container
            self.index = index
            super.init()
        }

        deinit {
            container.insert(storage.popContainer(), at: index)
        }
    }
}
