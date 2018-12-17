//
//  MessagePackStorage.swift
//  MessagePacker
//
//  Created by hirotaka on 2018/12/17.
//  Copyright © 2018 hiro. All rights reserved.
//

import Foundation

struct MessagePackStorage {
    private var containers = [Data]()

    var count: Int {
        return containers.count
    }

    var last: Data? {
        return containers.last
    }

    mutating func push(container: Data) {
        containers.append(container)
    }

    mutating func popContainer() -> Data {
        precondition(containers.count > 0, "Empty container stack.")
        return containers.popLast()!
    }
}
