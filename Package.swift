// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("DeprecateApplicationMain"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("GlobalConcurrency"),
    .enableUpcomingFeature("ImplicitOpenExistentials"),
    .enableUpcomingFeature("ImportObjcForwardDeclarations"),
    .enableUpcomingFeature("IsolatedDefaultValues"),
]

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
        .package(url: "https://github.com/apple/app-store-server-library-swift", exact: "2.1.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", exact: "4.2.2"),
        .package(url: "https://github.com/maiyama18/LicensesPlugin", exact: "0.2.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", exact: "2.6.4"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.3.3"),
        .package(url: "https://github.com/apple/swift-http-types", exact: "1.3.0"),
        .package(url: "https://github.com/apple/swift-format", exact: "510.1.0"),
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
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "IAPInterface",
            dependencies: [
                "IAPCore",
                // Use Model...
                .product(name: "AppStoreServerLibrary", package: "app-store-server-library-swift"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "IAPModel",
            dependencies: [
                "IAPInterface",
            ],
            swiftSettings: swiftSettings
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
            swiftSettings: swiftSettings,
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
