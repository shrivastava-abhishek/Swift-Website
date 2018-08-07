// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftWebDemo",
    dependencies: [
        // 2
        .package(url: "https://github.com/IBM-Swift/Kitura.git",
                 .upToNextMinor(from: "2.1.0")),
        // 3
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git",
                 .upToNextMinor(from: "1.7.1")),
        // 4
        .package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git",
                 .upToNextMinor(from: "2.0.1")),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git",
                .upToNextMinor(from: "1.8.4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftWebDemo",
            dependencies: ["Kitura" , "HeliumLogger", "CouchDB", "KituraStencil"],
            path: "Sources")
    ]
)
