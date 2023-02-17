//
//  SingleValueDecodingContainer+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

enum MessagePackableDecodingError: Error {
    case notMessagePackDecoder
}

extension SingleValueDecodingContainer {
    func decode<T: MessagePackable>(as type: T.Type) throws -> T where T.T == T {
        guard let messagePackContainer = self as? MessagePackDecoder.SingleValueContainer else {
            throw MessagePackableDecodingError.notMessagePackDecoder
        }
        return try messagePackContainer.decode(as: type)
    }
}
