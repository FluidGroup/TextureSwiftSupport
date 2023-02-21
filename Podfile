# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
use_frameworks!

target "Demo-TextureSwiftSuppoprt" do
  pod "Reveal-SDK"
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
