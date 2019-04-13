//
//  MessagePackType+FloatType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum FloatType {}
}

extension MessagePackType.FloatType {
    static var firstByte: UInt8 {
        return 0xca
    }

    static var range: Range<Int> {
        return 0..<5
    }

    static var dataRange: Range<Int> {
        return 1..<5
    }

    static func pack(for value: Float) -> Data {
        var data = Data([firstByte])
        data.append(packInteger(for: value.bitPattern.bigEndian))
        return data
    }

    static func unpack(for value: Data) throws -> Float {
        let unpacked: UInt32 = try unpackInteger(try value.subdata(dataRange))
        return Float(bitPattern: UInt32(bigEndian: unpacked))
    }
}
