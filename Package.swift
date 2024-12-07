// swift-tools-version: 6.0
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "EnumCompatibleTo",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "EnumCompatibleTo",
            targets: ["EnumCompatibleTo"]
        ),
        .executable(
            name: "EnumCompatibleToClient",
            targets: ["EnumCompatibleToClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .macro(
            name: "EnumCompatibleToMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "EnumCompatibleTo",
            dependencies: ["EnumCompatibleToMacros"]
        ),
        .executableTarget(
            name: "EnumCompatibleToClient",
            dependencies: ["EnumCompatibleTo"]
        ),
        .testTarget(
            name: "EnumCompatibleToTests",
            dependencies: [
                "EnumCompatibleToMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
