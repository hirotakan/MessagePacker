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
    enum CodingKeys: String, CodingKey {
        case seconds
        case nanoseconds
    }

    public func encode(to encoder: Encoder) throws {
        do {
            // First, try encoding as a `MessagePackable`, which requires a `MessagePackEncoder`.
            try encoder.singleValueContainer().encode(self)
        } catch let error as MessagePackableEncodingError where error == .notMessagePackEncoder {
            // If the caller is not using a `MessagePackEncoder`, then fall back to standard, non-MessagePack behavior.
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(seconds, forKey: .seconds)
            try container.encode(nanoseconds, forKey: .nanoseconds)
        }
    }

    public init(from decoder: Decoder) throws {
        do {
            // First, try decoding as a `MessagePackable`, which requires a `MessagePackDecoder`.
            self = try decoder.singleValueContainer().decode(as: MessagePackTimestamp.self)
        } catch let error as MessagePackableDecodingError where error == .notMessagePackDecoder {
            // If the caller is not using a `MessagePackDecoder`, then fall back to standard, non-MessagePack behavior.
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.seconds = try container.decode(Int64.self, forKey: .seconds)
            self.nanoseconds = try container.decode(Int64.self, forKey: .nanoseconds)
        }
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
