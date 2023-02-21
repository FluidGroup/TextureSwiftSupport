import Foundation
import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

@MainActor
extension Book {

  static func layerBacked() -> BookView {

    BookNavigationLink(title: "LayerBacking") {

      BookNodePreview {
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

      BookNodePreview {
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
