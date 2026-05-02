// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "Games",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "Games", targets: ["Games"])
    ],
    dependencies: [
        .package(path: "../../Core"),
        .package(path: "../../DesignSystem")
    ],
    targets: [
        .target(
            name: "Games",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "DesignSystem", package: "DesignSystem")
            ],
            path: "Sources/Games"
        )
    ]
)
