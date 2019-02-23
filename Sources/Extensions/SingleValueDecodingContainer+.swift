//
//  SingleValueDecodingContainer+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension SingleValueDecodingContainer {
    func decode<T: MessagePackable>(as type: T.Type) throws -> T where T.T == T {
        return try (self as! MessagePackDecoder.SingleValueContainer).decode(as: type)
    }
}
