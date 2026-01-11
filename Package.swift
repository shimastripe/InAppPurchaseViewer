// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InAppPurchaseViewer",
    defaultLocalization: "ja",
    platforms: [.macOS("14.4")],
    products: [
        .library(name: "IAPClient", targets: ["IAPClient"]),
        .library(name: "IAPCore", targets: ["IAPCore"]),
        .library(name: "IAPInterface", targets: ["IAPInterface"]),
        .library(name: "IAPModel", targets: ["IAPModel"]),
        .library(name: "IAPView", targets: ["IAPView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/app-store-server-library-swift", exact: "4.0.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", exact: "4.2.2"),
        .package(url: "https://github.com/maiyama18/LicensesPlugin", exact: "0.2.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", exact: "2.8.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.10.0"),
        .package(url: "https://github.com/apple/swift-http-types", exact: "1.5.1"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", exact: "1.4.5"),
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
        .testTarget(
            name: "IAPInterfaceTests",
            dependencies: [
                "IAPInterface",
                .product(name: "AppStoreServerLibrary", package: "app-store-server-library-swift"),
            ]
        ),
        .target(
            name: "IAPModel",
            dependencies: [
                "IAPInterface"
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
                .plugin(name: "LicensesPlugin", package: "LicensesPlugin")
            ]
        ),
        .testTarget(
            name: "IAPViewTests",
            dependencies: ["IAPView"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
