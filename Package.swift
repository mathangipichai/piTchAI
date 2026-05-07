// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "LiquidGlassBanking",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "LiquidGlassBanking",
            targets: ["LiquidGlassBanking"])
    ],
    targets: [
        .executableTarget(
            name: "LiquidGlassBanking",
            dependencies: [],
            path: "LiquidGlassBanking"
        )
    ]
)
