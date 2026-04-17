// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AppData",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17),
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
