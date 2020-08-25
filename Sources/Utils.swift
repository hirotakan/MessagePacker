//
//  Utils.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

func packInteger<T: BinaryInteger>(for int: T) -> Data {
    return withUnsafePointer(to: int) {
        Data(buffer: UnsafeBufferPointer(start: $0, count: 1))
    }
}

func unpackInteger<T: BinaryInteger>(_ value: Data) throws -> T {
    return try value.withUnsafeBytes {
        guard let address = $0.baseAddress else {
            throw MessagePackError.emptyData
        }
        return address.assumingMemoryBound(to: T.self).pointee
    }
}
