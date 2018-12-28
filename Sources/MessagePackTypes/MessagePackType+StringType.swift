//
//  MessagePackType+StringType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum StringType {
        case fixstr
        case string8
        case string16
        case string32
    }
}

extension MessagePackType.StringType {
    init(_ value: String) {
        let utf8 = value.utf8
        let count = utf8.count
        if count < 0x1a {
            self = .fixstr
        } else if count < 0x100 {
            self = .string8
        } else if count < 0x10000 {
            self = .string16
        } else {
            self = .string32
        }
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.StringType.fixFirstByteRange:
            self = .fixstr
        case MessagePackType.StringType.string8.firstByte!:
            self = .string8
        case MessagePackType.StringType.string16.firstByte!:
            self = .string16
        case MessagePackType.StringType.string32.firstByte!:
            self = .string32
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.StringType {
    static var fixFirstByteRange: ClosedRange<UInt8> {
        return 0xa0...0xbf
    }

    var firstByte: UInt8? {
        switch self {
        case .fixstr:
            return nil
        case .string8:
            return 0xd9
        case .string16:
            return 0xda
        case .string32:
            return 0xdb
        }
    }

    private var lengthRange: Range<Int> {
        switch self {
        case .fixstr:
            return 0..<1
        case .string8:
            return 1..<2
        case .string16:
            return 1..<3
        case .string32:
            return 1..<5
        }
    }
}

extension MessagePackType.StringType {
    func length(_ value: Data) throws -> Int {
        switch self {
        case .fixstr:
            let length: UInt8 = unpackInteger(try value.subdata(lengthRange))
                - MessagePackType.StringType.fixFirstByteRange.lowerBound
            return Int(length)
        case .string8:
            let length: UInt8 = unpackInteger(try value.subdata(lengthRange))
            return Int(length)
        case .string16:
            let length: UInt16 = unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        case .string32:
            let length: UInt32 = unpackInteger(try value.subdata(lengthRange))
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

extension MessagePackType.StringType {
    static func pack(for value: String) -> Data {
        let utf8 = value.utf8
        let count = utf8.count
        let data = Data(utf8)
        let type = MessagePackType.StringType(value)
        let firstByte = type.firstByte.map { Data([$0]) } ?? Data([MessagePackType.StringType.fixFirstByteRange.lowerBound | UInt8(count)])
        switch type {
        case .fixstr:
            return firstByte + data
        case .string8:
            return firstByte + packInteger(for: UInt8(count).bigEndian) + data
        case .string16:
            return firstByte + packInteger(for: UInt16(count).bigEndian) + data
        case .string32:
            return firstByte + packInteger(for: UInt32(count).bigEndian) + data
        }
    }

    static func unpack(for value: Data) throws -> String {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.StringType(firstByte)
        let dataRange = try type.dataRange(value)
        let value = try value.subdata(dataRange)

        guard let data = String(data: value, encoding: .utf8) else {
            throw MessagePackError.invalidData
        }
        return data
    }
}
