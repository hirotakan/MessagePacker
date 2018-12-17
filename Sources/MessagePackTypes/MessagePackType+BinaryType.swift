//
//  MessagePackType+BinaryType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum BinaryType {
        case binary8
        case binary16
        case binary32
    }
}

extension MessagePackType.BinaryType {
    init(_ value: Data) {
        let count = value.count
        if count < 0x100 {
            self = .binary8
        } else if count < 0x10000 {
            self = .binary16
        } else {
            self = .binary32
        }
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.BinaryType.binary8.firstByte:
            self = .binary8
        case MessagePackType.BinaryType.binary16.firstByte:
            self = .binary16
        case MessagePackType.BinaryType.binary32.firstByte:
            self = .binary32
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.BinaryType {
    var firstByte: UInt8 {
        switch self {
        case .binary8:
            return 0xc4
        case .binary16:
            return 0xc5
        case .binary32:
            return 0xc6
        }
    }

    private var lengthRange: Range<Int> {
        switch self {
        case .binary8:
            return 1..<2
        case .binary16:
            return 1..<3
        case .binary32:
            return 1..<5
        }
    }
}

extension MessagePackType.BinaryType {
    func length(_ value: Data) throws -> Int {
        switch self {
        case .binary8:
            let length: UInt8 = unpackInteger(try value.subdata(lengthRange))
            return Int(length)
        case .binary16:
            let length: UInt16 = unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        case .binary32:
            let length: UInt32 = unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        }
    }

    func dataRange(_ value: Data) throws -> Range<Int> {
        return lengthRange.endIndex..<(lengthRange.endIndex + (try length(value)))
    }

    func range(_ value: Data) throws -> Range<Int> {
        return 0..<(try dataRange(value).endIndex)
    }
}

extension MessagePackType.BinaryType {
    static func pack(for value: Data) -> Data {
        let count = value.count
        let type = MessagePackType.BinaryType(value)
        let firstByte = Data([type.firstByte])
        switch type {
        case .binary8:
            return firstByte + packInteger(for: UInt8(count).bigEndian) + value
        case .binary16:
            return firstByte + packInteger(for: UInt16(count).bigEndian) + value
        case .binary32:
            return firstByte + packInteger(for: UInt32(count).bigEndian) + value
        }
    }

    static func unpack(for value: Data) throws -> Data {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.BinaryType(firstByte)
        return try value.subdata(type.dataRange(value))
    }
}
