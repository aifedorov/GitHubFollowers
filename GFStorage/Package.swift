// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GFStorage",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "GFStorage",
            targets: ["GFStorage"]),
    ],
    targets: [
        .target(
            name: "GFStorage"),
        .testTarget(
            name: "GFStorageTests",
            dependencies: ["GFStorage"]
        ),
    ]
)
