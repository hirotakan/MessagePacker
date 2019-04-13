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
    init(_ count: Int) {
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
            let length: UInt8 = try unpackInteger(try value.subdata(lengthRange))
            return Int(length)
        case .binary16:
            let length: UInt16 = try unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        case .binary32:
            let length: UInt32 = try unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        }
    }

    func dataRange(_ value: Data) throws -> Range<Int> {
        let endIndex = lengthRange.upperBound
        return endIndex..<(endIndex + (try length(value)))
    }

    func range(_ value: Data) throws -> Range<Int> {
        return 0..<(try dataRange(value).upperBound)
    }
}

extension MessagePackType.BinaryType {
    static func pack(for value: Data) -> Data {
        let count = value.count
        let type = MessagePackType.BinaryType(count)
        var data = Data([type.firstByte])
        switch type {
        case .binary8:
            data.append(packInteger(for: UInt8(count).bigEndian))
        case .binary16:
            data.append(packInteger(for: UInt16(count).bigEndian))
        case .binary32:
            data.append(packInteger(for: UInt32(count).bigEndian))
        }
        data.append(value)
        return data
    }

    static func unpack(for value: Data) throws -> Data {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.BinaryType(firstByte)
        return try value.subdata(type.dataRange(value))
    }
}
