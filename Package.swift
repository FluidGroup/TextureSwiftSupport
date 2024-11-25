// swift-tools-version:6.0
import PackageDescription

let package = Package(
  name: "TextureSwiftSupport",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(name: "TextureSwiftSupport", targets: ["TextureSwiftSupport"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ntnmrndn/Texture.git", branch: "antoine/swift6"),
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
  swiftLanguageModes: [.v6]
)
