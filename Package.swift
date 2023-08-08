// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "TextureSwiftSupport",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(name: "TextureSwiftSupport", targets: ["TextureSwiftSupport"]),
  ],
  dependencies: [
    .package(url: "https://github.com/FluidGroup/Texture.git", from: "3.0.2"),
    .package(url: "https://github.com/FluidGroup/Descriptors", from: "0.2.0"),
  ],
  targets: [
    .target(
      name: "TextureSwiftSupport", 
      dependencies: [
        .product(name: "AsyncDisplayKit", package: "Texture"),
        .product(name: "Descriptors", package: "Descriptors")
      ],
      path: "Sources"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
