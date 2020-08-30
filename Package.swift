// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "MessagePacker",
    platforms: [
        .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "MessagePacker", targets: ["MessagePacker"]),
    ],
    targets: [
        .target(name: "MessagePacker", dependencies: [], path: "Sources"),
        .testTarget(name: "MessagePackerTests", dependencies: ["MessagePacker"]),
    ],
    swiftLanguageVersions: [.v5]
)
