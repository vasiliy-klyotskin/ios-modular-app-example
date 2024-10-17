// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CompositionSupport",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CompositionSupport",
            type: .dynamic,
            targets: [
                "CompositionSupport"
            ]
        ),
    ],
    targets: [
        .target(
            name: "CompositionSupport"
        ),
    ]
)
