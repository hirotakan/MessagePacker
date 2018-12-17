//
//  MessagePackType+FixIntType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum FixIntType {
        case negative
        case positive
    }
}

extension MessagePackType.FixIntType {
    init?(_ value: Int8) {
        switch value {
        case MessagePackType.FixIntType.negativeFirstByteRange.map { (~Int8($0.upperBound - $0.lowerBound) + 1)...0x00 }:
            self = .negative
        case MessagePackType.FixIntType.positiveFirstByteRange.map(Int8.init):
            self = .positive
        default:
            return nil
        }
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.FixIntType.negativeFirstByteRange:
            self = .negative
        case MessagePackType.FixIntType.positiveFirstByteRange:
            self = .positive
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.FixIntType {
    static var negativeFirstByteRange: ClosedRange<UInt8> {
        return 0xe0...0xff
    }

    static var positiveFirstByteRange: ClosedRange<UInt8> {
        return 0x00...0x7f
    }
}
