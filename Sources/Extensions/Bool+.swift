//
//  Bool+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Bool: MessagePackable {
    func pack() -> Data {
        return MessagePackType.BooleanType.pack(for: self)
    }

    static func unpack(for value: Data) throws -> Bool {
        return try MessagePackType.BooleanType.unpack(for: value)
    }
}
