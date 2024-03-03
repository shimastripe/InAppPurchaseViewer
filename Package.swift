// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InAppPurchaseViewer",
    defaultLocalization: "ja",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "IAPClient", targets: ["IAPClient"]),
        .library(name: "IAPCore", targets: ["IAPCore"]),
        .library(name: "IAPInterface", targets: ["IAPInterface"]),
        .library(name: "IAPModel", targets: ["IAPModel"]),
        .library(name: "IAPView", targets: ["IAPView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/app-store-server-library-swift", from: "1.0.2"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/maiyama18/LicensesPlugin", from: "0.1.6"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.5.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.2.1"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.0.3"),
        .package(url: "https://github.com/apple/swift-format", from: "509.0.0"),
    ],
    targets: [
        .target(
            name: "IAPClient",
            dependencies: [
                "IAPInterface",
                .product(name: "AppStoreServerLibrary", package: "app-store-server-library-swift"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
            ]
        ),
        .testTarget(
            name: "IAPClientTests",
            dependencies: ["IAPClient"]
        ),
        .target(
            name: "IAPCore",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "IAPInterface",
            dependencies: [
                "IAPCore",
                // Use Model...
                .product(name: "AppStoreServerLibrary", package: "app-store-server-library-swift"),
            ]
        ),
        .target(
            name: "IAPModel",
            dependencies: [
                "IAPInterface",
            ]
        ),
        .testTarget(
            name: "IAPModelTests",
            dependencies: ["IAPModel"]
        ),
        .target(
            name: "IAPView",
            dependencies: [
                "IAPModel",
                .product(name: "Sparkle", package: "Sparkle"),
            ],
            plugins: [
                .plugin(name: "LicensesPlugin", package: "LicensesPlugin"),
            ]
        ),
        .testTarget(
            name: "IAPViewTests",
            dependencies: ["IAPView"]
        ),
    ]
)
