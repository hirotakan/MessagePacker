//
//  ClosedRange+.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

extension ClosedRange {
    func map<T: Comparable>(_ transform: (Bound) throws -> T) rethrows -> ClosedRange<T> {
        let lowerBound = try transform(self.lowerBound)
        let upperBound = try transform(self.upperBound)
        return lowerBound...upperBound
    }

    func map<T: Comparable>(_ transform: (ClosedRange<Bound>) throws -> ClosedRange<T>) rethrows -> ClosedRange<T> {
        return try transform(self)
    }
}
