//
//  UInt16+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension UInt16: MessagePackable {
    func pack() -> Data {
        return UInt(self).pack()
    }

    static func unpack(for value: Data) throws -> UInt16 {
        return try UInt16(UInt.unpack(for: value))
    }
}
