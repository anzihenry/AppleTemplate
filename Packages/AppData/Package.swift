// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AppData",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .watchOS(.v26),
        .tvOS(.v26),
    ],
    products: [
        .library(name: "AppData", targets: ["AppData"]),
    ],
    dependencies: [
        .package(path: "../AppCore"),
    ],
    targets: [
        .target(
            name: "AppData",
            dependencies: [
                .product(name: "AppCore", package: "AppCore"),
            ]
        ),
        .testTarget(
            name: "AppDataTests",
            dependencies: ["AppData"]
        ),
    ]
)
