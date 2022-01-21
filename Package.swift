// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ParallaxView",
    platforms: [
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "ParallaxView",
            targets: ["ParallaxView"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ParallaxView",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
