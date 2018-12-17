//
//  UInt8+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension UInt8: MessagePackable {
    func pack() -> Data {
        return UInt(self).pack()
    }

    static func unpack(for value: Data) throws -> UInt8 {
        return try UInt8(UInt.unpack(for: value))
    }
}
