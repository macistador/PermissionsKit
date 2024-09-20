// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PermissionsKit",
    platforms: [.iOS(.v15)], //v15
    products: [
        .library(
            name: "PermissionsKit",
            targets: ["PermissionsKit"]),
    ],
    targets: [
        .target(
            name: "PermissionsKit"),

    ]
)
