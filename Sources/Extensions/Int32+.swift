//
//  Int32+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Int32: MessagePackable {
    func pack() -> Data {
        return Int(self).pack()
    }

    static func unpack(for value: Data) throws -> Int32 {
        return try Int32(Int.unpack(for: value))
    }
}
