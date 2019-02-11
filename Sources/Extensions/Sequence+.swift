//
//  Sequence+.swift
//  MessagePacker
//
//  Created by Hirotaka Nishiyama on 2019/02/11.
//  Copyright © 2019年 hiro. All rights reserved.
//

import Foundation

#if !swift(>=4.1)
extension Sequence {
    func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        return try flatMap(transform)
    }
}
#endif
