
Pod::Spec.new do |spec|

  spec.name         = "TextureSwiftSupport"
  spec.version      = "1.9.1"
  spec.summary      = "Integrations Texture with Swift"
  spec.description  = <<-DESC
  TextureSwiftSupport helps developers with Swift language's features.
                   DESC

  spec.homepage     = "https://github.com/TextureCommunity/TextureSwiftSupport"
  spec.license      = "MIT"
  spec.author             = { "Muukii" => "muukii.app@gmail.com" }
  spec.social_media_url   = "https://twitter.com/muukii_app"
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/TextureCommunity/TextureSwiftSupport.git", :tag => "#{spec.version}" }
  spec.source_files  = "TextureSwiftSupport", "TextureSwiftSupport/**/*.swift"

  spec.swift_versions = ['5.1']
  spec.dependency "Texture/Core", "~> 2.8"

end
