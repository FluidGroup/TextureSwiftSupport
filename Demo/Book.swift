import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

let book = Book(title: "TextureSwiftSupport") {

  BookNavigationLink(title: "Components") {
    BookNavigationLink(title: "InteractiveNode") {
      BookNodePreview {
        InteractiveNode(animation: .translucent) {
          AnyDisplayNode { node, _ in
            LayoutSpec {
              node._makeNode {
                let textNode = ASTextNode()
                textNode.attributedText = NSAttributedString(string: "InteractiveNode")
                return textNode
              }
              .padding(8)
              .background(
                node._makeNode {
                  ShapeLayerNode.roundedCorner(radius: 16).setShapeFillColor(.systemYellow)
                }
              )
            }
          }
        }
      }
    }
  }

  BookPush(title: "Transition") {
    TransitionLayoutViewController()
  }

  BookPush(title: "Instagram post") {
    InstagramPostCellViewController()
  }

  BookPush(title: "Adaptive layout") {
    AdaptiveLayoutViewController()
  }

  BookPush(title: "Composition") {
    CompositionCatalogViewController()
  }

  BookPush(title: "Test recursive layout") {
    RecursiveLayoutViewController()
  }
}
