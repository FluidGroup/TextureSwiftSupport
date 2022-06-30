// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "TextureSwiftSupport",
  platforms: [
    .iOS(.v11),
  ],
  products: [
    .library(name: "TextureSwiftSupport", targets: ["TextureSwiftSupport"]),
  ],
  dependencies: [
    .package(url: "https://github.com/3a4oT/Texture.git", branch: "spm"),
  ],
  targets: [
    .target(
      name: "TextureSwiftSupport", 
      dependencies: [
        .product(name: "AsyncDisplayKit", package: "Texture")
      ],
      path: "Sources"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
