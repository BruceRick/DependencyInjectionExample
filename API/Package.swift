// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "API",
    platforms: [
        .iOS(.v26),
    ],
    products: [
        .library(
            name: "API",
            targets: ["API"]
        ),
    ],
    targets: [
        .target(
            name: "API"
        ),
        .testTarget(
            name: "APITests",
            dependencies: ["API"]
        ),
    ]
)
