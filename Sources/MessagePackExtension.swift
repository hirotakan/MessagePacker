//
//  MessagePackExtension.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

public struct MessagePackExtension: Equatable {
    public var type: Int8
    public var data: Data
    
    public init(type: Int8, data: Data) {
        self.type = type
        self.data = data
    }
}

extension MessagePackExtension {
    public init(timestamp: MessagePackTimestamp) {
        self.type = -1

        switch ((timestamp.seconds >> 34), UInt64(truncatingIfNeeded: timestamp.nanoseconds << 34 | timestamp.seconds)) {
        case let (0, value) where (value & 0xffffffff00000000) == 0:
            self.data = packInteger(for: UInt32(value).bigEndian)
        case let (0, value):
            self.data = packInteger(for: value.bigEndian)
        default:
            self.data = packInteger(for: UInt32(timestamp.nanoseconds).bigEndian) + packInteger(for: Int64(timestamp.seconds).bigEndian)
        }
    }
}

extension MessagePackExtension: Codable {
    public func encode(to encoder: Encoder) throws {
        try encoder.singleValueContainer().encode(self)
    }

    public init(from decoder: Decoder) throws {
        self = try decoder.singleValueContainer().decode(as: MessagePackExtension.self)
    }
}

extension MessagePackExtension: MessagePackable {
    func pack() -> Data {
        return MessagePackType.ExtensionType.pack(for: self)
    }

    static func unpack(for value: Data) throws -> MessagePackExtension {
        return try MessagePackType.ExtensionType.unpack(for: value)
    }
}
