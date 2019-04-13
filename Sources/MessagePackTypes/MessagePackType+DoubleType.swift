//
//  MessagePackType+DoubleType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum DoubleType {}
}

extension MessagePackType.DoubleType {
    static var firstByte: UInt8 {
        return 0xcb
    }

    static var range: Range<Int> {
        return 0..<9
    }

    static var dataRange: Range<Int> {
        return 1..<9
    }

    static func pack(for value: Double) -> Data {
        var data = Data([firstByte])
        data.append(packInteger(for: value.bitPattern.bigEndian))
        return data
    }

    static func unpack(for value: Data) throws -> Double {
        let unpacked: UInt64 = try unpackInteger(try value.subdata(dataRange))
        return Double(bitPattern: UInt64(bigEndian: unpacked))
    }
}
