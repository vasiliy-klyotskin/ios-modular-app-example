// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authentication",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Authentication",
            type: .dynamic,
            targets: [
                "Authentication"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Primitives"),
        .package(path: "../DesignScheme"),
        .package(path: "../Networking"),
        .package(path: "../CompositionSupport"),
        .package(path: "../PrimitivesDSL"),
        .package(path: "../CompositionTestingTools"),
        .package(path: "../NetworkingTestingTools")
    ],
    targets: [
        .target(
            name: "Authentication",
            dependencies: [
                .product(name: "CompositionSupport", package: "CompositionSupport"),
                .product(name: "Networking", package: "Networking"),
                .product(name: "DesignScheme", package: "DesignScheme"),
                .product(name: "Primitives", package: "Primitives"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "AuthenticationTests",
            dependencies: [
                .target(name: "Authentication"),
                .product(name: "CompositionTestingTools", package: "CompositionTestingTools"),
                .product(name: "NetworkingTestingTools", package: "NetworkingTestingTools"),
                .product(name: "PrimitivesDSL", package: "PrimitivesDSL"),
            ]
        )
    ]
)
