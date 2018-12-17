//
//  Int16+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Int16: MessagePackable {
    func pack() -> Data {
        return Int(self).pack()
    }

    static func unpack(for value: Data) throws -> Int16 {
        return try Int16(Int.unpack(for: value))
    }
}
