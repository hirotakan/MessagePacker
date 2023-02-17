//
//  TimestampUnpackedTests.swift
//  MessagePackerTests
//
//  Created by Hirotaka Nishiyama on 2018/11/19.
//  Copyright © 2018年 hiro. All rights reserved.
//

import XCTest
@testable import MessagePacker

class TimestampUnpackedTests: XCTestCase {
    let decoder = MessagePackDecoder()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTimestamp32() {
        let input = Data([214, 255, 0, 0, 0, 1])
        let output = MessagePackTimestamp(seconds: 1, nanoseconds: 0)
        XCTAssertEqual(try decoder.decode(MessagePackTimestamp.self, from: input), output)
    }

    func testTimestamp64() {
        let input = Data([215, 255, 50, 1, 148, 236, 91, 242, 22, 42])
        let output = MessagePackTimestamp(seconds: 1542592042, nanoseconds: 209741115)
        XCTAssertEqual(try decoder.decode(MessagePackTimestamp.self, from: input), output)
    }

    func testTimestamp96() {
        let input = Data([199, 12, 255, 25, 69, 229, 222, 0, 0, 0, 14, 211, 132, 20, 74])
        let output = MessagePackTimestamp(seconds: 63678190666, nanoseconds: 424011230)
        XCTAssertEqual(try decoder.decode(MessagePackTimestamp.self, from: input), output)
    }

    func testNestedStruct() {
        struct License: Codable, Equatable {
            let key: String
            let status: String
            let type: String
            let flash_counter: Int
            let current_stage: String
            let flash_date: Date?
            let cvn: String
        }

        struct Vehicle: Codable, Equatable {
            let vin: String
            let ecus: [String]
            let stage: String
            let licenses: [License]
        }

        let input = Data([132,163,118,105,110,177,87,68,68,49,55,54,48,53,50,49,74,51,48,56,53,55,50,164,101,99,117,115,144,165,115,116,97,103,101,168,79,82,73,71,73,78,65,76,168,108,105,99,101,110,115,101,115,145,135,163,107,101,121,167,77,73,67,75,69,89,49,166,115,116,97,116,117,115,166,65,67,84,73,86,69,164,116,121,112,101,163,69,67,85,173,102,108,97,115,104,95,99,111,117,110,116,101,114,0,173,99,117,114,114,101,110,116,95,115,116,97,103,101,168,79,82,73,71,73,78,65,76,170,102,108,97,115,104,95,100,97,116,101,214,255,96,164,193,34,163,99,118,110,160])


        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let flash_date = dateFormatter.date(from: "2021-05-19T07:41:22Z")
        let license = License(key: "MICKEY1", status: "ACTIVE", type: "ECU", flash_counter: 0, current_stage: "ORIGINAL", flash_date: flash_date, cvn: "")
        let output = Vehicle(vin: "WDD1760521J308572", ecus: [], stage: "ORIGINAL", licenses: [license])

        XCTAssertEqual(try decoder.decode(Vehicle.self, from: input), output)
    }

    func testSupportsNonMessagePackDecoder() {
        let input = """
            {
              "nanoseconds" : 209741115,
              "seconds" : 1542592042
            }
            """.data(using: .utf8)!

        let jsonDecoder = JSONDecoder()

        let output = MessagePackTimestamp(seconds: 1542592042, nanoseconds: 209741115)
        XCTAssertEqual(try jsonDecoder.decode(MessagePackTimestamp.self, from: input), output)
    }
}
