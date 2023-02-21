import StorybookKit
import StorybookKitTextureSupport
import SwiftUI
import TextureSwiftSupport

@MainActor
@available(iOS 13, *)
extension Book {
  static var hostingNode: some BookView {
    BookNavigationLink(title: "HostingNode") {
      BookNodePreview(expandsWidth: false, preservedHeight: 200) {
        
        let bar = ASDisplayNode()
        bar.backgroundColor = .systemPink

        let hosting = HostingNode { _ in
          VStack {
            Text("Hello")
              .blur(radius: 2)
              .padding()
              .background(Color.blue)
            InteractiveView()
          }
        }

        return AnyDisplayNode { _, _ in
          LayoutSpec {
            VStackLayout {
              hosting
              bar
                .height(10)
            }
          }
        }
      }
    }
  }
}

@available(iOS 13.0, *)
private struct InteractiveView: View {
  @State var isOn: Bool = false

  var body: some View {
    Button("toggle") {
      isOn.toggle()
    }
    if isOn {
      Color.gray.frame(height: 30)
    }
  }
}
