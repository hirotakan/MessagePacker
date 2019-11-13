# MessagePacker

[![Build Status](https://travis-ci.org/hirotakan/MessagePacker.svg?branch=master)](https://travis-ci.org/hirotakan/MessagePacker)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![License](https://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods](https://img.shields.io/cocoapods/v/MessagePacker.svg)](http://cocoadocs.org/docsets/MessagePacker)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)

**MessagePacker** is a [MessagePack](http://msgpack.org/) encoder & decoder for Swift and supports [Codable](https://developer.apple.com/documentation/swift/codable).

- Message Pack specification: https://github.com/msgpack/msgpack/blob/master/spec.md

## Usage

```swift
import MessagePacker

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

struct Landmark: Codable {
    var name: String
    var foundingYear: Int
    var location: Coordinate
}

let input = Landmark(
    name: "Mojave Desert",
    foundingYear: 0,
    location: Coordinate(
        latitude: 35.0110079,
        longitude: -115.4821313
    )
)

let data = try! MessagePackEncoder().encode(input)
let landmark = try! MessagePackDecoder().decode(Landmark.self, from: data)

print([UInt8](data))
print(landmark)

// [131, 164, 110, 97, 109, 101, 173, 77, 111, 106,
//  97, 118, 101, 32, 68, 101, 115, 101, 114, 116,
//  172, 102, 111, 117, 110, 100, 105, 110, 103, 89,
//  101, 97, 114, 0, 168, 108, 111, 99, 97, 116,
//  105, 111, 110, 130, 168, 108, 97, 116, 105, 116,
//  117, 100, 101, 203, 64, 65, 129, 104, 180, 245,
//  63, 179, 169, 108, 111, 110, 103, 105, 116, 117,
//  100, 101, 203, 192, 92, 222, 219, 61, 61, 120, 49]

// Landmark(
//     name: "Mojave Desert",
//     foundingYear: 0,
//     location: MessagePackerTests.Coordinate(
//         latitude: 35.0110079,
//         longitude: -115.4821313
//     )
// )

```

## Installation

### Carthage

Add the following to your Cartfile:

```terminal
github "hirotakan/MessagePacker"
```

### CocoaPods

Add the following to your Podfile:

```terminal
pod 'MessagePacker'
```

### SwiftPM

Add MessagePacker as a dependency:

```swift
import PackageDescription

let package = Package(
    name: "YourApp",
    dependencies: [
        .Package(url: "https://github.com/hirotakan/MessagePacker.git", majorVersion: 0),
    ]
)
```

## Requirements
 - Swift 5.0 or later
 - iOS 8.0 or later
 - macOS 10.10 or later
 - tvOS 9.0 or later
 - watchOS 2.0 or later


## License

MessagePacker is released under the MIT license. See [LICENSE](https://github.com/hirotakan/MessagePacker/blob/master/LICENSE) for details.
