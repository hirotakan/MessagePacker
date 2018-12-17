//
//  MessagePackType+NilType.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/12/15.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

extension MessagePackType {
    enum NilType {}
}

extension MessagePackType.NilType {
    static var firstByte: UInt8 {
        return 0xc0
    }
}
