# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

def texture
  pod 'Texture/Core', '~> 3' #, git: 'git@github.com:TextureGroup/Texture.git', branch: 'master'
end

target 'TextureSwiftSupport' do
  # Comment the next line if you don't want to use dynamic frameworks

  texture

  target 'TextureSwiftSupportTests' do
    inherit! :search_paths
  end

end

target 'Demo' do

  texture
  pod 'Reveal-SDK'
  pod 'GlossButtonNode'
  pod 'TextureSwiftSupport', path: './'
  pod 'TypedTextAttributes'
end
