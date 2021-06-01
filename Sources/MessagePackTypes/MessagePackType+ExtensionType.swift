//
//  MessagePackType+ExtensionType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum ExtensionType {
        case fixext1
        case fixext2
        case fixext4
        case fixext8
        case fixext16
        case ext8
        case ext16
        case ext32
    }
}

extension MessagePackType.ExtensionType {
    init(_ value: MessagePackExtension) {
        let count = value.data.count
        switch count {
        case 1:
            self = .fixext1
        case 2:
            self = .fixext2
        case 4:
            self = .fixext4
        case 8:
            self = .fixext8
        case 16:
            self = .fixext16
        case let count where count <= 0xff:
            self = .ext8
        case let count where count <= 0xffff:
            self = .ext16
        default:
            self = .ext32
        }
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.ExtensionType.fixext1.firstByte:
            self = .fixext1
        case MessagePackType.ExtensionType.fixext2.firstByte:
            self = .fixext2
        case MessagePackType.ExtensionType.fixext4.firstByte:
            self = .fixext4
        case MessagePackType.ExtensionType.fixext8.firstByte:
            self = .fixext8
        case MessagePackType.ExtensionType.fixext16.firstByte:
            self = .fixext16
        case MessagePackType.ExtensionType.ext8.firstByte:
            self = .ext8
        case MessagePackType.ExtensionType.ext16.firstByte:
            self = .ext16
        case MessagePackType.ExtensionType.ext32.firstByte:
            self = .ext32
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.ExtensionType {
    var firstByte: UInt8 {
        switch self {
        case .fixext1:
            return 0xd4
        case .fixext2:
            return 0xd5
        case .fixext4:
            return 0xd6
        case .fixext8:
            return 0xd7
        case .fixext16:
            return 0xd8
        case .ext8:
            return 0xc7
        case .ext16:
            return 0xc8
        case .ext32:
            return 0xc9
        }
    }

    private var dataTypeIndex: Int {
        switch self {
        case .fixext1,
             .fixext2,
             .fixext4,
             .fixext8,
             .fixext16:
            return 1
        case .ext8:
            return 2
        case .ext16:
            return 3
        case .ext32:
            return 5
        }
    }

    private var lengthRange: Range<Int>? {
        switch self {
        case .fixext1,
             .fixext2,
             .fixext4,
             .fixext8,
             .fixext16:
            return nil
        case .ext8,
             .ext16,
             .ext32:
            return 1..<dataTypeIndex
        }
    }
}

extension MessagePackType.ExtensionType {
    func range(_ value: Data) throws -> Range<Int> {
        return 0..<(try dataRange(value).upperBound)
    }

    private func length(_ value: Data) throws -> Int {
        switch self {
        case .fixext1:
            return 1
        case .fixext2:
            return 2
        case .fixext4:
            return 4
        case .fixext8:
            return 8
        case .fixext16:
            return 16
        case .ext8:
            let length: UInt8 = try unpackInteger(try value.subdata(lengthRange!))
            return Int(length)
        case .ext16:
            let length: UInt16 = try unpackInteger(try value.subdata(lengthRange!))
            return Int(length.bigEndian)
        case .ext32:
            let length: UInt32 = try unpackInteger(try value.subdata(lengthRange!))
            return Int(length.bigEndian)
        }
    }

    private func dataType(_ value: Data) throws -> Int8 {
        guard value.count >= dataTypeIndex else { throw MessagePackError.outOfRange }

        return Int8(bitPattern: value[value.startIndex + dataTypeIndex])
    }

    private func dataRange(_ value: Data) throws -> Range<Int> {
        let startIndex = dataTypeIndex + 1
        return try startIndex..<startIndex + length(value)
    }
}

extension MessagePackType.ExtensionType {
    static func pack(for value: MessagePackExtension) -> Data {
        let count = value.data.count
        let dataType = Data([UInt8(bitPattern: value.type)])
        let extensionType = MessagePackType.ExtensionType(value)
        let firstByte = Data([extensionType.firstByte])

        switch extensionType {
        case .fixext1,
             .fixext2,
             .fixext4,
             .fixext8,
             .fixext16:
            return firstByte + dataType + value.data
        case .ext8:
            return firstByte + Data([UInt8(count)]) + dataType + value.data
        case .ext16:
            return firstByte + packInteger(for: UInt16(count).bigEndian) + dataType + value.data
        case .ext32:
            return firstByte + packInteger(for: UInt32(count).bigEndian) + dataType + value.data
        }
    }

    static func unpack(for value: Data) throws -> MessagePackExtension {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let extensionType = try MessagePackType.ExtensionType(firstByte)
        let dataType = try extensionType.dataType(value)
        let dataRange = try extensionType.dataRange(value)
        let data = try value.subdata(dataRange)
        return MessagePackExtension(type: dataType, data: data)
    }
}
