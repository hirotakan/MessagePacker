//
//  Int64+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Int64: MessagePackable {
    func pack() -> Data {
        return Int(self).pack()
    }

    static func unpack(for value: Data) throws -> Int64 {
        return try Int64(Int.unpack(for: value))
    }
}
