//
//  Utils.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

func packInteger<T: BinaryInteger>(for int: T) -> Data {
    var data = int
    return Data(buffer: UnsafeBufferPointer(start: &data, count: 1))
}

func unpackInteger<T: BinaryInteger>(_ value: Data) -> T {
    return value.withUnsafeBytes { $0.pointee }
}
