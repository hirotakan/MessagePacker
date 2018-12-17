//
//  Double+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Double: MessagePackable {
    func pack() -> Data {
        return MessagePackType.DoubleType.pack(for: self)
    }

    static func unpack(for value: Data) throws -> Double {
        return try MessagePackType.DoubleType.unpack(for: value)
    }
}
