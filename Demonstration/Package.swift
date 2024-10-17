// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Demonstration",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Demonstration",
            type: .dynamic,
            targets: ["Demonstration"]),
    ],
    dependencies: [
        .package(path: "../CompositionSupport"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(
            name: "Demonstration",
            dependencies: [
                .product(
                    name: "Networking",
                    package: "Networking"
                ),
                .product(
                    name: "CompositionSupport",
                    package: "CompositionSupport"
                ),
            ]
        ),
    ]
)
