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
    ],
    dependencies: [
        // Add any external dependencies here
    ],
    targets: [
        .target(
            name: "Quotes",
            dependencies: []),
        .testTarget(
            name: "QuotesTests",
            dependencies: ["Quotes"]),
    ]
) 