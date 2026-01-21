// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataLayer",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer"]
        ),
    ],
    dependencies: [
        .package(name: "DomainLayer", path: "../DomainLayer"),
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: [
                .product(name: "DomainLayer", package: "DomainLayer"),
            ]
        ),
    ]
)
