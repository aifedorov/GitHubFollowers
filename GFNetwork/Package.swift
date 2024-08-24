// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GFNetwork",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "GFNetwork",
            targets: ["GFNetwork"]),
    ],
    targets: [
        .target(
            name: "GFNetwork"),
        .testTarget(
            name: "GFNetworkTests",
            dependencies: ["GFNetwork"]
        ),
    ]
)
