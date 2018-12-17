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
    init(_ value: UInt) {
        switch value {
        case MessagePackType.FixIntType.positiveFirstByteRange.map(UInt.init):
            self = .fixint
        case UInt(UInt8.min)...UInt(UInt8.max):
            self = .uint8
        case UInt(UInt16.min)...UInt(UInt16.max):
            self = .uint16
        case UInt(UInt32.min)...UInt(UInt32.max):
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
        return 0..<dataRange.endIndex
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
    static func pack(for value: UInt) -> Data {
        let type = MessagePackType.UnsignedIntegerType(value)
        let firstByte = type.firstByte.map { Data([$0]) } ?? packInteger(for: UInt8(value).bigEndian)
        switch type {
        case .fixint:
            return firstByte
        case .uint8:
            return firstByte + packInteger(for: UInt8(value).bigEndian)
        case .uint16:
            return firstByte + packInteger(for: UInt16(value).bigEndian)
        case .uint32:
            return firstByte + packInteger(for: UInt32(value).bigEndian)
        case .uint64:
            return firstByte + packInteger(for: UInt64(value).bigEndian)
        }
    }

    static func unpack(for value: Data) throws -> UInt {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.UnsignedIntegerType(firstByte)
        switch type {
        case .fixint:
            return UInt(firstByte)
        case .uint8:
            return UInt(UInt8(bigEndian: unpackInteger(try value.subdata(type.dataRange))))
        case .uint16:
            return UInt(UInt16(bigEndian: unpackInteger(try value.subdata(type.dataRange))))
        case .uint32:
            return UInt(UInt32(bigEndian: unpackInteger(try value.subdata(type.dataRange))))
        case .uint64:
            return UInt(UInt64(bigEndian: unpackInteger(try value.subdata(type.dataRange))))
        }
    }
}
