//
//  MessagePackType+MapType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum MapType {
        case fixmap
        case map16
        case map32
    }
}

extension MessagePackType.MapType {
    init(_ count: Int) {
        if count < 0xf {
            self = .fixmap
        } else if count < 0x10000 {
            self = .map16
        } else {
            self = .map32
        }
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.MapType.fixFirstByteRange:
            self = .fixmap
        case MessagePackType.MapType.map16.firstByte!:
            self = .map16
        case MessagePackType.MapType.map32.firstByte!:
            self = .map32
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.MapType {
    static var fixFirstByteRange: ClosedRange<UInt8> {
        return 0x80...0x8f
    }

    var firstByte: UInt8? {
        switch self {
        case .fixmap:
            return nil
        case .map16:
            return 0xde
        case .map32:
            return 0xdf
        }
    }

    private var lengthRange: Range<Int> {
        switch self {
        case .fixmap:
            return 0..<1
        case .map16:
            return 1..<3
        case .map32:
            return 1..<5
        }
    }
}

extension MessagePackType.MapType {
    func range(_ value: Data) throws -> Range<Int> {
        return 0..<(try endIndex(for: value))
    }

    private func length(_ value: Data) throws -> Int {
        switch self {
        case .fixmap:
            let length: UInt8 = try unpackInteger(try value.subdata(lengthRange))
                - MessagePackType.MapType.fixFirstByteRange.lowerBound
            return Int(length)
        case .map16:
            let length: UInt16 = try unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        case .map32:
            let length: UInt32 = try unpackInteger(try value.subdata(lengthRange))
            return Int(length.bigEndian)
        }
    }

    private func endIndex(for value: Data) throws -> Int {
        let startIndex = lengthRange.upperBound
        let length = try self.length(value)

        return try (0..<length).reduce(into: startIndex) { index, _ in
            let key = try value.subdata(startIndex: index).firstMessagePackeValue()
            let value = try value.subdata(startIndex: index + key.count).firstMessagePackeValue()
            index += (key.count + value.count)
        }
    }
}

extension MessagePackType.MapType {
    static func split(for value: Data) throws -> [String : Data] {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.MapType(firstByte)
        let startIndex = type.lengthRange.upperBound
        let length = try type.length(value)

        return try (0..<length)
            .reduce(into: (dictionary: [String : Data](), index: startIndex)) { args, _ in
                let key = try value.subdata(startIndex: args.index).firstMessagePackeValue()
                let value = try value.subdata(startIndex: args.index + key.count).firstMessagePackeValue()
                args.dictionary[try String.unpack(for: key)] = value
                args.index += (key.count + value.count)
            }
            .dictionary
    }

    static func pack(count: Int, value: Data) -> Data {
        let type = MessagePackType.MapType(count)
        switch type {
        case .fixmap:
            var data = Data([MessagePackType.MapType.fixFirstByteRange.lowerBound | UInt8(count)])
            data.append(value)
            return data
        case .map16:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: UInt16(count).bigEndian))
            data.append(value)
            return data
        case .map32:
            var data = Data([type.firstByte!])
            data.append(packInteger(for: UInt32(count).bigEndian))
            data.append(value)
            return data
        }
    }
}
