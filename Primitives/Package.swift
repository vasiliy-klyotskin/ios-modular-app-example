// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Primitives",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Primitives",
            type: .dynamic,
            targets: ["Primitives"]
        ),
    ],
    dependencies: [
        .package(path: "../CompositionSupport"),
        .package(path: "../DesignScheme"),
        .package(path: "../PrimitivesDSL"),
        .package(path: "../CompositionTestingTools")
    ],
    targets: [
        .target(
            name: "Primitives",
            dependencies: [
                .product(
                    name: "DesignScheme",
                    package: "DesignScheme"
                ),
                .product(
                    name: "CompositionSupport",
                    package: "CompositionSupport"
                )
            ]
        ),
        .testTarget(
            name: "PrimitivesTests",
            dependencies: [
                .target(name: "Primitives"),
                .product(name: "PrimitivesDSL", package: "PrimitivesDSL"),
                .product(name: "CompositionTestingTools", package: "CompositionTestingTools"),
            ]
        ),
    ]
)
