//
//  MessagePackType+BooleanType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum BooleanType {
        case `false`
        case `true`
    }
}

extension MessagePackType.BooleanType {
    init(_ value: Bool) {
        self = value ? .true : .false
    }

    init(_ firstByte: UInt8) throws {
        switch firstByte {
        case MessagePackType.BooleanType.false.firstByte:
            self = .false
        case MessagePackType.BooleanType.true.firstByte:
            self = .true
        default:
            throw MessagePackError.invalidData
        }
    }
}

extension MessagePackType.BooleanType {
    var firstByte: UInt8 {
        switch self {
        case .false:
            return 0xc2
        case .true:
            return 0xc3
        }
    }

    var range: Range<Int> {
        return 0..<1
    }
}

extension MessagePackType.BooleanType {
    static func pack(for value: Bool) -> Data {
        return Data([MessagePackType.BooleanType(value).firstByte])
    }

    static func unpack(for value: Data) throws -> Bool {
        guard let firstByte = value.first else { throw MessagePackError.emptyData }

        let type = try MessagePackType.BooleanType(firstByte)
        return type == .true
    }
}
