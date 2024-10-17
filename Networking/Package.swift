// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Networking",
            type: .dynamic,
            targets: [
                "Networking"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../CompositionSupport"),
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                .product(
                    name: "CompositionSupport",
                    package: "CompositionSupport"
                )
            ]
        )
    ]
)
