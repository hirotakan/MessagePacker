// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "MessagePacker",
    products: [
        .library(name: "MessagePacker", targets: ["MessagePacker"]),
    ],
    targets: [
        .target(name: "MessagePacker", dependencies: [], path: "Sources"),
        .testTarget(name: "MessagePackerTests", dependencies: ["MessagePacker"]),
    ],
    swiftLanguageVersions: [4]
)
