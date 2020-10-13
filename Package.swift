// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TextureSwiftSupport",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "TextureSwiftSupport", type: .dynamic, targets: ["TextureSwiftSupport"])
    ],
    targets: [
        .target(
            name: "TextureSwiftSupport",
            path: ".",
            sources: ["TextureSwiftSupport/"]
        )
    ]
)
