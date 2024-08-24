// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GFCommon",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "GFCommon",
            targets: ["GFCommon"]),
    ],
    targets: [
        .target(
            name: "GFCommon"),
        .testTarget(
            name: "GFCommonTests",
            dependencies: ["GFCommon"]
        ),
    ]
)
