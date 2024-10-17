// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignScheme",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "DesignScheme",
            type: .dynamic,
            targets: [
                "DesignScheme"
            ]
        ),
    ],
    targets: [
        .target(
            name: "DesignScheme",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
