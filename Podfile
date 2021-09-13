# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

def texture
  pod "Texture/Core", "~> 3" #, git: 'git@github.com:TextureGroup/Texture.git', branch: 'master'
end

target "TextureSwiftSupport" do
  # Comment the next line if you don't want to use dynamic frameworks

  pod "Verge/Store"
  texture

  target "TextureSwiftSupportTests" do
    inherit! :search_paths
  end
end

target "Demo-TextureSwiftSuppoprt" do
  platform :ios, '12.1'
  texture
  pod "TypedTextAttributes"
  pod "GlossButtonNode"
  pod "TextureSwiftSupport", path: "./"
  pod "Reveal-SDK"
  pod "StorybookKit"
  pod "StorybookUI"
  pod "StorybookKitTextureSupport"
  pod "EasyPeasy"
end

pre_install do |installer|
  installer.aggregate_targets.each { |target|
    puts "📦 #{target.name}"

    def print_pods(pod, depth)
      puts "#{depth} -> #{pod.name}"
      pod.dependent_targets.each { |d|
        print_pods d, depth + "  "
      }
    end

    target.pod_targets.each { |t|
      print_pods t, ""
    }
  }
end
