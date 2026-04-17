// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AppCore",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .watchOS(.v26),
        .tvOS(.v26),
    ],
    products: [
        .library(name: "AppCore", targets: ["AppCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.25.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.12.0"),
        .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "AppCore",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Navigation", package: "swift-navigation"),
            ]
        ),
        .testTarget(
            name: "AppCoreTests",
            dependencies: ["AppCore"]
        ),
    ]
)
