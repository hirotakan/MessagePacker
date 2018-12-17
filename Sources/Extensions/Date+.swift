//
//  Date+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Date: MessagePackable {
    func pack() -> Data {
        let ext = MessagePackExtension(timestamp: MessagePackTimestamp(date: self))
        return MessagePackType.ExtensionType.pack(for: ext)
    }

    static func unpack(for value: Data) throws -> Date {
        let ext = try MessagePackType.ExtensionType.unpack(for: value)
        return Date(timestamp: try MessagePackTimestamp(extension: ext))
    }
}

extension Date {
    init(timestamp: MessagePackTimestamp) {
        let timeInterval = Double(timestamp.seconds) + Double(timestamp.nanoseconds) / 1_000_000_000
        self = .init(timeIntervalSince1970: timeInterval)
    }
}
