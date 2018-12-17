//
//  String+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension String: MessagePackable {
    func pack() -> Data {
        return MessagePackType.StringType.pack(for: self)
    }

    static func unpack(for value: Data) throws -> String {
        return try MessagePackType.StringType.unpack(for: value)
    }
}
