//
//  MessagePackable.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2018/09/30.
//  Copyright © 2018年 hiro. All rights reserved.
//

import Foundation

protocol MessagePackable {
    associatedtype T

    func pack() -> Data
    static func unpack(for value: Data) throws -> T
}
