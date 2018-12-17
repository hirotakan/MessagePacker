//
//  UInt32+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension UInt32: MessagePackable {
    func pack() -> Data {
        return UInt(self).pack()
    }

    static func unpack(for value: Data) throws -> UInt32 {
        return try UInt32(UInt.unpack(for: value))
    }
}
