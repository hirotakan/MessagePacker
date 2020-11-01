//
//  Data+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Data: MessagePackable {
    func pack() -> Data {
        return MessagePackType.BinaryType.pack(for: self)
    }

    static func unpack(for value: Data) throws -> Data {
        return try MessagePackType.BinaryType.unpack(for: value)
    }
}

extension Data {
    func subdata(startIndex: Int) throws -> Data {
        return try subdata(startIndex..<self.endIndex - self.startIndex)
    }

    func subdata(_ range: Range<Int>) throws -> Data {
        let start = startIndex + range.lowerBound
        let end = startIndex + range.upperBound

        guard start <= endIndex && end <= endIndex else { throw MessagePackError.outOfRange }

        return self[start..<end]
    }
}

extension Data {
    func firstMessagePackeValue() throws -> Data {
        guard let firstByte = self.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType(firstByte)
        switch type {
        case .nil:
            return Data([MessagePackType.NilType.firstByte])
        case let .signedInteger(type):
            return try self.subdata(type.range)
        case let .unsignedInteger(type):
            return try self.subdata(type.range)
        case let .boolean(type):
            return try self.subdata(type.range)
        case let .string(type):
            return try self.subdata(type.range(self))
        case let .binary(type):
            return try self.subdata(type.range(self))
        case .float:
            return try self.subdata(MessagePackType.FloatType.range)
        case .double:
            return try self.subdata(MessagePackType.DoubleType.range)
        case let .array(type):
            return try self.subdata(type.range(self))
        case let .map(type):
            return try self.subdata(type.range(self))
        case let .extension(type):
            return try self.subdata(type.range(self))
        }
    }
}
