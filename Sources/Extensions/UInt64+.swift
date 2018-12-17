//
//  UInt64+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension UInt64: MessagePackable {
    func pack() -> Data {
        return UInt(self).pack()
    }

    static func unpack(for value: Data) throws -> UInt64 {
        return try UInt64(UInt.unpack(for: value))
    }
}
