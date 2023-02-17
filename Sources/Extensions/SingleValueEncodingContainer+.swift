//
//  SingleValueEncodingContainer+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

enum MessagePackableEncodingError: Error {
    case notMessagePackEncoder
}

extension SingleValueEncodingContainer {
    func encode<T: MessagePackable>(_ value: T) throws {
        guard let messagePackContainer = self as? MessagePackEncoder.SingleValueContainer else {
            throw MessagePackableEncodingError.notMessagePackEncoder
        }
        try messagePackContainer.encode(from: value)
    }
}
