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
    init<T: BinaryInteger>(_ value: T) {
        switch value {
        case T(Int8.min)...T(Int8.max):
            self = MessagePackType.FixIntType(Int8(value)).map { .fixint($0) } ?? .int8
        case T(Int16.min)...T(Int16.max):
            self = .int16
        case T(Int32.min)...T(Int32.max):
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
        return 0..<dataRange.upperBound
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
    static func pack<T: BinaryInteger>(for value: T) -> Data {
        let type = MessagePackType.SignedIntegerType(value)
        switch type {
        case .fixint:
            return packInteger(for: Int8(value).bigEndian)
        case .int8:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: Int8(value).bigEndian))
            return data
        case .int16:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: Int16(value).bigEndian))
            return data
        case .int32:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: Int32(value).bigEndian))
            return data
        case .int64:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: Int64(value).bigEndian))
            return data
        }
    }

    static func unpack<T: BinaryInteger>(for value: Data) throws -> T {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.SignedIntegerType(firstByte)
        switch type {
        case .fixint:
            return T(Int8(bitPattern: firstByte))
        case .int8:
            return T(Int8(bigEndian: try unpackInteger(try value.subdata(type.dataRange))))
        case .int16:
            return T(Int16(bigEndian: try unpackInteger(try value.subdata(type.dataRange))))
        case .int32:
            return T(Int32(bigEndian: try unpackInteger(try value.subdata(type.dataRange))))
        case .int64:
            return T(Int64(bigEndian: try unpackInteger(try value.subdata(type.dataRange))))
        }
    }
}
