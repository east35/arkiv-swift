// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "Auth",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "AuthFeature", targets: ["AuthFeature"])
    ],
    dependencies: [
        .package(path: "../../Core"),
        .package(path: "../../DesignSystem")
    ],
    targets: [
        .target(
            name: "AuthFeature",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "DesignSystem", package: "DesignSystem")
            ],
            path: "Sources/AuthFeature"
        ),
        .testTarget(
            name: "AuthFeatureTests",
            dependencies: ["AuthFeature"],
            path: "Tests/AuthFeatureTests"
        )
    ]
)
