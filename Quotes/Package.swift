// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Quotes",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Quotes",
            targets: ["Quotes"]),
        .library(
            name: "QuotesWidget",
            targets: ["QuotesWidget"]),
    ],
    dependencies: [
        // Add any external dependencies here
    ],
    targets: [
        .target(
            name: "Quotes",
            dependencies: [],
            resources: [
                .process("Resources/Localization"),
                .process("Resources/StoreKit")
            ]),
        .target(
            name: "QuotesWidget",
            dependencies: ["Quotes"]),
        .testTarget(
            name: "QuotesTests",
            dependencies: ["Quotes"]),
    ]
) 