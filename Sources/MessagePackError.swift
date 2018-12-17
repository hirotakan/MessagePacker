//
//  MessagePackError.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

enum MessagePackError: Swift.Error {
    case emptyData
    case invalidData
    case outOfRange
}

extension MessagePackError {
    func asDecodingError<T>(_ type: T.Type, codingPath: [CodingKey]) -> DecodingError {
        switch self {
        case .emptyData:
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(type) value but found null instead.")
            return DecodingError.valueNotFound(type, context)
        case .invalidData,
             .outOfRange:
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Expected to decode \(type) but it failed.")
            return DecodingError.dataCorrupted(context)
        }
    }
}
