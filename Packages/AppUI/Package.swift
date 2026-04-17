// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AppUI",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .watchOS(.v26),
        .tvOS(.v26),
    ],
    products: [
        .library(name: "AppUI", targets: ["AppUI"]),
    ],
    dependencies: [
        .package(path: "../AppCore"),
    ],
    targets: [
        .target(
            name: "AppUI",
            dependencies: [
                .product(name: "AppCore", package: "AppCore"),
            ]
        ),
        .testTarget(
            name: "AppUITests",
            dependencies: ["AppUI"]
        ),
    ]
)
