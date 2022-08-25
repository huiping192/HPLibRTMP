// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HPLibRTMP",
    dependencies: [
        .package(url: "https://github.com/pili-engineering/pili-librtmp", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "HPLibRTMP",
            dependencies: [
                "pili-librtmp"
            ]),
        .testTarget(
            name: "HPLibRTMPTests",
            dependencies: ["HPLibRTMP"]),
    ]
)
