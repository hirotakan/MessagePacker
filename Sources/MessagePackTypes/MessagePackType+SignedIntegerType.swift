//
//  MessagePackType+SignedIntegerType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum SignedIntegerType {
        case fixint(FixIntType)
        case int8
        case int16
        case int32
        case int64
    }
}

extension MessagePackType.SignedIntegerType {
    init(_ value: Int) {
        switch value {
        case Int(Int8.min)...Int(Int8.max):
            self = MessagePackType.FixIntType(Int8(value)).map { .fixint($0) } ?? .int8
        case Int(Int16.min)...Int(Int16.max):
            self = .int16
        case Int(Int32.min)...Int(Int32.max):
            self = .int32
        default:
            self = .int64
        }
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.FixIntType.negativeFirstByteRange,
             MessagePackType.FixIntType.positiveFirstByteRange:
            self = .fixint(try MessagePackType.FixIntType(firstByte))
        case MessagePackType.SignedIntegerType.int8.firstByte!:
            self = .int8
        case MessagePackType.SignedIntegerType.int16.firstByte!:
            self = .int16
        case MessagePackType.SignedIntegerType.int32.firstByte!:
            self = .int32
        case MessagePackType.SignedIntegerType.int64.firstByte!:
            self = .int64
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.SignedIntegerType {
    var firstByte: UInt8? {
        switch self {
        case .fixint:
            return nil
        case .int8:
            return 0xd0
        case .int16:
            return 0xd1
        case .int32:
            return 0xd2
        case .int64:
            return 0xd3
        }
    }

    var range: Range<Int> {
        return 0..<dataRange.endIndex
    }

    private var dataRange: Range<Int> {
        switch self {
        case .fixint:
            return 0..<1
        case .int8:
            return 1..<2
        case .int16:
            return 1..<3
        case .int32:
            return 1..<5
        case .int64:
            return 1..<9
        }
    }
}

extension MessagePackType.SignedIntegerType {
    static func pack(for value: Int) -> Data {
        let type = MessagePackType.SignedIntegerType(value)
        let firstByte = type.firstByte.map { Data([$0]) } ?? packInteger(for: Int8(value).bigEndian)
        switch type {
        case .fixint:
            return firstByte
        case .int8:
            return firstByte + packInteger(for: Int8(value).bigEndian)
        case .int16:
            return firstByte + packInteger(for: Int16(value).bigEndian)
        case .int32:
            return firstByte + packInteger(for: Int32(value).bigEndian)
        case .int64:
            return firstByte + packInteger(for: Int64(value).bigEndian)
        }
    }

    static func unpack(for value: Data) throws -> Int {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.SignedIntegerType(firstByte)
        switch type {
        case .fixint:
            return Int(Int8(bitPattern: firstByte))
        case .int8:
            return Int(Int8(bigEndian: unpackInteger(try value.subdata(type.dataRange))))
        case .int16:
            return Int(Int16(bigEndian: unpackInteger(try value.subdata(type.dataRange))))
        case .int32:
            return Int(Int32(bigEndian: unpackInteger(try value.subdata(type.dataRange))))
        case .int64:
            return Int(Int64(bigEndian: unpackInteger(try value.subdata(type.dataRange))))
        }
    }
}
