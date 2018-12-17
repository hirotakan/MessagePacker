//
//  MessagePackType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

enum MessagePackType {
    case `nil`
    case signedInteger(SignedIntegerType)
    case unsignedInteger(UnsignedIntegerType)
    case boolean(BooleanType)
    case float
    case double
    case string(StringType)
    case binary(BinaryType)
    case array(ArrayType)
    case map(MapType)
    case `extension`(ExtensionType)
}

extension MessagePackType {
    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case NilType.firstByte:
            self = .nil
        case FixIntType.negativeFirstByteRange,
             SignedIntegerType.int8.firstByte!,
             SignedIntegerType.int16.firstByte!,
             SignedIntegerType.int32.firstByte!,
             SignedIntegerType.int64.firstByte!:
            self = .signedInteger(try SignedIntegerType(firstByte))
        case FixIntType.positiveFirstByteRange,
             UnsignedIntegerType.uint8.firstByte!,
             UnsignedIntegerType.uint16.firstByte!,
             UnsignedIntegerType.uint32.firstByte!,
             UnsignedIntegerType.uint64.firstByte!:
            self = .unsignedInteger(try UnsignedIntegerType(firstByte))
        case BooleanType.false.firstByte,
             BooleanType.true.firstByte:
            self = .boolean(try BooleanType(firstByte))
        case StringType.fixFirstByteRange,
             StringType.string8.firstByte!,
             StringType.string16.firstByte!,
             StringType.string32.firstByte!:
            self = .string(try StringType(firstByte))
        case BinaryType.binary8.firstByte,
             BinaryType.binary16.firstByte,
             BinaryType.binary32.firstByte:
            self = .binary(try BinaryType(firstByte))
        case FloatType.firstByte:
            self = .float
        case DoubleType.firstByte:
            self = .double
        case ArrayType.fixFirstByteRange,
             ArrayType.array16.firstByte!,
             ArrayType.array32.firstByte!:
            self = .array(try ArrayType(firstByte))
        case MapType.fixFirstByteRange,
             MapType.map16.firstByte!,
             MapType.map32.firstByte!:
            self = .map(try MapType(firstByte))
        case ExtensionType.fixext1.firstByte,
             ExtensionType.fixext2.firstByte,
             ExtensionType.fixext4.firstByte,
             ExtensionType.fixext8.firstByte,
             ExtensionType.fixext16.firstByte,
             ExtensionType.ext8.firstByte,
             ExtensionType.ext16.firstByte,
             ExtensionType.ext32.firstByte:
            self = .extension(try ExtensionType(firstByte))
        default:
            throw MessagePackError.invalidData
        }
    }
}
