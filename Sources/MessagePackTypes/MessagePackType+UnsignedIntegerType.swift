//
//  MessagePackType+UnsignedIntegerType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum UnsignedIntegerType {
        case fixint
        case uint8
        case uint16
        case uint32
        case uint64
    }
}

extension MessagePackType.UnsignedIntegerType {
    init<T: BinaryInteger>(_ value: T) {
        switch value {
        case MessagePackType.FixIntType.positiveFirstByteRange.map { T($0) }:
            self = .fixint
        case T(UInt8.min)...T(UInt8.max):
            self = .uint8
        case T(UInt16.min)...T(UInt16.max):
            self = .uint16
        case T(UInt32.min)...T(UInt32.max):
            self = .uint32
        default:
            self = .uint64
        }
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.FixIntType.positiveFirstByteRange:
            self = .fixint
        case MessagePackType.UnsignedIntegerType.uint8.firstByte!:
            self = .uint8
        case MessagePackType.UnsignedIntegerType.uint16.firstByte!:
            self = .uint16
        case MessagePackType.UnsignedIntegerType.uint32.firstByte!:
            self = .uint32
        case MessagePackType.UnsignedIntegerType.uint64.firstByte!:
            self = .uint64
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.UnsignedIntegerType {
    var firstByte: UInt8? {
        switch self {
        case .fixint:
            return nil
        case .uint8:
            return 0xcc
        case .uint16:
            return 0xcd
        case .uint32:
            return 0xce
        case .uint64:
            return 0xcf
        }
    }

    var range: Range<Int> {
        return 0..<dataRange.upperBound
    }

    private var dataRange: Range<Int> {
        switch self {
        case .fixint:
            return 0..<1
        case .uint8:
            return 1..<2
        case .uint16:
            return 1..<3
        case .uint32:
            return 1..<5
        case .uint64:
            return 1..<9
        }
    }
}

extension MessagePackType.UnsignedIntegerType {
    static func pack<T: BinaryInteger>(for value: T) -> Data {
        let type = MessagePackType.UnsignedIntegerType(value)
        switch type {
        case .fixint:
            return packInteger(for: UInt8(value).bigEndian)
        case .uint8:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: UInt8(value).bigEndian))
            return data
        case .uint16:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: UInt16(value).bigEndian))
            return data
        case .uint32:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: UInt32(value).bigEndian))
            return data
        case .uint64:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: UInt64(value).bigEndian))
            return data
        }
    }

    static func unpack<T: BinaryInteger>(for value: Data) throws -> T {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.UnsignedIntegerType(firstByte)
        switch type {
        case .fixint:
            return T(firstByte)
        case .uint8:
            return T(UInt8(bigEndian: try unpackInteger(try value.subdata(type.dataRange))))
        case .uint16:
            return T(UInt16(bigEndian: try unpackInteger(try value.subdata(type.dataRange))))
        case .uint32:
            return T(UInt32(bigEndian: try unpackInteger(try value.subdata(type.dataRange))))
        case .uint64:
            return T(UInt64(bigEndian: try unpackInteger(try value.subdata(type.dataRange))))
        }
    }
}
