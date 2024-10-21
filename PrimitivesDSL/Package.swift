// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrimitivesDSL",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "PrimitivesDSL",
            type: .dynamic,
            targets: ["PrimitivesDSL"]
        ),
    ],
    dependencies: [
        .package(path: "../Primitives")
    ],
    targets: [
        .target(
            name: "PrimitivesDSL",
            dependencies: [.product(name: "Primitives", package: "Primitives")]
        ),
    ]
)
