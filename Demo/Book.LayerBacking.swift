import Foundation
import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

extension Book {

  @MainActor
  static func layerBacked() -> BookPage {

    BookPage(title: "LayerBacking") {

      BookNodePreview { _ in
        AnyDisplayNode { node, _ in
          LayoutSpec {
            VStackLayout {
              node._makeNode {
                with(ASTextNode()) {
                  $0.attributedText = NSAttributedString(string: "Hello")
                }
              }
            }
          }
        }
      }

      BookNodePreview { _ in
        AnyDisplayNode { node, _ in
          LayoutSpec {
            VStackLayout {
              node._makeNode {
                with(ASTextNode()) {
                  $0.attributedText = NSAttributedString(string: "Hello")
                  $0.isLayerBacked = true
                }
              }
            }
          }
        }
        .setIsLayerBacked(true)
      }
    }
  }

}
