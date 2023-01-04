//
//  MessagePackTimestamp.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/14.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

public struct MessagePackTimestamp: Equatable {
    public var seconds: Int64
    public var nanoseconds: Int64
    
    public init(seconds: Int64, nanoseconds: Int64) {
        self.seconds = seconds
        self.nanoseconds = nanoseconds
    }
}

extension MessagePackTimestamp {
    public init(date: Date) {
        let timeInterval = date.timeIntervalSince1970
        self.seconds = Int64(timeInterval)
        self.nanoseconds = Int64(timeInterval.truncatingRemainder(dividingBy: 1) * 1_000_000_000)
    }

    public init(extension ext: MessagePackExtension) throws {
        switch ext.data.count {
        case 4:
            let time = UInt32(bigEndian: try unpackInteger(ext.data))
            self.seconds = Int64(time)
            self.nanoseconds = 0
        case 8:
            let time = UInt64(bigEndian: try unpackInteger(ext.data))
            self.seconds = Int64(time & 0x00000003ffffffff)
            self.nanoseconds = Int64(time >> 34)
        case 12:
            let nanosec = UInt32(bigEndian: try unpackInteger(try ext.data.subdata(0..<4)))
            let sec = Int64(bigEndian: try unpackInteger(try ext.data.subdata(4..<12)))
            self.seconds = Int64(sec)
            self.nanoseconds = Int64(nanosec)
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackTimestamp: Codable {
    public func encode(to encoder: Encoder) throws {
        try encoder.singleValueContainer().encode(self)
    }

    public init(from decoder: Decoder) throws {
        self = try decoder.singleValueContainer().decode(as: MessagePackTimestamp.self)
    }
}

extension MessagePackTimestamp: MessagePackable {
    func pack() -> Data {
        let ext = MessagePackExtension(timestamp: self)
        return MessagePackType.ExtensionType.pack(for: ext)
    }

    static func unpack(for value: Data) throws -> MessagePackTimestamp {
        let ext = try MessagePackType.ExtensionType.unpack(for: value)
        return try MessagePackTimestamp(extension: ext)
    }
}
