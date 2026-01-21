// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationLayer",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PresentationLayer",
            targets: ["PresentationLayer"]
        ),
    ],
    dependencies: [
        .package(name: "DomainLayer", path: "../DomainLayer"),
        .package(url: "https://github.com/hmlongco/Factory", .upToNextMajor(from: "2.5.3")),
    ],
    targets: [
        .target(
            name: "PresentationLayer",
            dependencies: [
                .product(name: "DomainLayer", package: "DomainLayer"),
                .product(name: "Factory", package: "Factory"),
            ]
        ),
        .testTarget(
            name: "PresentationLayerTests",
            dependencies: ["PresentationLayer"]
        ),
    ]
)
