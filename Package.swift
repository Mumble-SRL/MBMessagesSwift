// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MBMessagesSwift",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "MBMessagesSwift",
            targets: ["MBMessagesSwift"])

    ],
    dependencies: [
        .package(url: "https://github.com/Mumble-SRL/MBurgerSwift.git", from: "1.0.0"),
        .package(url: "https://github.com/Mumble-SRL/MPush-Swift.git", from: "0.3.2")
    ],
    targets: [
        .target(
            name: "MBMessagesSwift",
            dependencies: ["MBurgerSwift", "MPushSwift"],
            path: "MBMessagesSwift"
        )
    ]
)
