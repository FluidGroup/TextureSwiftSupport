Pod::Spec.new do |spec|
  spec.name = "TextureSwiftSupport"
  spec.version = "3.19.0"
  spec.summary = "A tool kit for Texture"
  spec.description = <<-DESC
  A library that gains Texture more power in Swift.
                   DESC

  spec.homepage = "https://github.com/TextureCommunity/TextureSwiftSupport"
  spec.license = "MIT"
  spec.author = { "Muukii" => "muukii.app@gmail.com" }
  spec.social_media_url = "https://twitter.com/muukii_app"
  spec.platform = :ios, "12.0"
  spec.source = { :git => "https://github.com/TextureCommunity/TextureSwiftSupport.git", :tag => "#{spec.version}" }

  spec.swift_versions = ["5.6"]
  spec.dependency "Texture/Core", ">= 3"
  spec.weak_frameworks = ["Combine", "SwiftUI"]

  spec.default_subspecs = ["LayoutSpecBuilders", "Components", "Extensions", "Experiments"]

  spec.subspec "LayoutSpecBuilders" do |ss|
    ss.source_files = "Sources/LayoutSpecBuilders/**/*.swift"
  end

  spec.subspec "Components" do |ss|
    ss.source_files = "Sources/Components/**/*.swift"
    ss.dependency "TextureSwiftSupport/LayoutSpecBuilders"
    ss.dependency "Descriptors", ">= 0.2.1"
  end

  spec.subspec "Extensions" do |ss|
    ss.source_files = "Sources/Extensions/**/*.swift"
  end

  spec.subspec "Experiments" do |ss|
    ss.source_files = "Sources/Experiments/**/*.swift"
  end
end
