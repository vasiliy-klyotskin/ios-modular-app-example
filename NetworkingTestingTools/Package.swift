// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkingTestingTools",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "NetworkingTestingTools",
            type: .dynamic,
            targets: ["NetworkingTestingTools"]
        ),
    ],
    dependencies: [
        .package(path: "../Networking")
    ],
    targets: [
        .target(
            name: "NetworkingTestingTools",
            dependencies: [
                .product(name: "Networking", package: "Networking")
            ]
        ),
    ]
)
