//
//  Int+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Int: MessagePackable {
    func pack() -> Data {
        return MessagePackType.SignedIntegerType.pack(for: self)
    }

    static func unpack(for value: Data) throws -> Int {
        return try MessagePackType.SignedIntegerType.unpack(for: value)
    }
}
