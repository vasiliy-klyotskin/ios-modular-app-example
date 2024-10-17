// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CompositionTestingTools",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "CompositionTestingTools",
            type: .dynamic,
            targets: [
                "CompositionTestingTools"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../CompositionSupport")
    ],
    targets: [
        .target(
            name: "CompositionTestingTools",
            dependencies: [
                .product(name: "CompositionSupport", package: "CompositionSupport")
            ]
        ),
    ]
)
