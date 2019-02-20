//
//  SingleValueEncodingContainer+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension SingleValueEncodingContainer {
    func encode<T: MessagePackable>(_ value: T) throws {
        try (self as! MessagePackEncoder.SingleValueContainer).encode(from: value)
    }
}
