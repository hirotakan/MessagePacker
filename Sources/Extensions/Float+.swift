//
//  Float+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension Float: MessagePackable {
    func pack() -> Data {
        return MessagePackType.FloatType.pack(for: self)
    }

    static func unpack(for value: Data) throws -> Float {
        return try MessagePackType.FloatType.unpack(for: value)
    }
}
