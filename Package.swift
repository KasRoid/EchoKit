// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EchoKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "EchoKit",
            targets: ["EchoKit"]),
    ],
    targets: [
        .target(
            name: "EchoKit",
            path: "Sources/EchoKit"
        ),
        .testTarget(
            name: "EchoKitTests",
            dependencies: ["EchoKit"],
            path: "Tests/EchoKitTests"
        ),
    ]
)
