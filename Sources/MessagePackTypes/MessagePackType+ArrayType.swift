//
//  MessagePackType+ArrayType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum ArrayType {
        case fixarray
        case array16
        case array32
    }
}

extension MessagePackType.ArrayType {
    init(_ count: Int) {
        if count < 0xf {
            self = .fixarray
        } else if count < 0x10000 {
            self = .array16
        } else {
            self = .array32
        }
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.ArrayType.fixFirstByteRange:
            self = .fixarray
        case MessagePackType.ArrayType.array16.firstByte!:
            self = .array16
        case MessagePackType.ArrayType.array32.firstByte!:
            self = .array32
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.ArrayType {
    static var fixFirstByteRange: ClosedRange<UInt8> {
        return 0x90...0x9f
    }

    var firstByte: UInt8? {
        switch self {
        case .fixarray:
            return nil
        case .array16:
            return 0xdc
        case .array32:
            return 0xdd
        }
    }

    private var lengthRange: Range<Int> {
        switch self {
        case .fixarray:
            return 0..<1
        case .array16:
            return 1..<3
        case .array32:
            return 1..<5
        }
    }
}

extension MessagePackType.ArrayType {
    func range(_ value: Data) throws -> Range<Int> {
        return 0..<(try endIndex(for: value))
    }

    private func length(for value: Data) throws -> Int {
        switch self {
        case .fixarray:
            let length: UInt8 = try unpackInteger(try value.subdata(lengthRange))
                - MessagePackType.ArrayType.fixFirstByteRange.lowerBound
            return Int(length)
        case .array16:
            let length: UInt16 = try unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        case .array32:
            let length: UInt32 = try unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        }
    }

    private func endIndex(for value: Data) throws -> Int {
        let startIndex = lengthRange.upperBound
        let length = try self.length(for: value)

        return try (0..<length).reduce(into: startIndex) { index, _ in
            let value = try value.subdata(startIndex: index).firstMessagePackeValue()
            index += value.count
        }
    }
}

extension MessagePackType.ArrayType {
    static func split(for value: Data) throws -> [Data] {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.ArrayType(firstByte)
        let startIndex = type.lengthRange.upperBound
        let length = try type.length(for: value)

        return try (0..<length)
            .reduce(into: (array: [Data](), index: startIndex)) { args, _ in
                let value = try value.subdata(startIndex: args.index).firstMessagePackeValue()
                args.array.append(value)
                args.index += value.count
            }
            .array
    }

    static func pack(count: Int, value: Data) -> Data {
        let type = MessagePackType.ArrayType(count)
        switch type {
        case .fixarray:
            var data = Data([MessagePackType.ArrayType.fixFirstByteRange.lowerBound | UInt8(count)])
            data.append(value)
            return data
        case .array16:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: UInt16(count).bigEndian))
            data.append(value)
            return data
        case .array32:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: UInt32(count).bigEndian))
            data.append(value)
            return data
        }
    }
}
