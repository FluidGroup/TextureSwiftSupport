import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

extension Book {

  private static func makeBody() -> ASDisplayNode {
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

  @MainActor
  static func bookInteractiveNode() -> BookView {
    BookNavigationLink(title: "InteractiveNode") {
      BookNodePreview {
        InteractiveNode(animation: .translucent) {
          makeBody()
        }
      }

      BookSection(title: "With Haptics") {

        BookForEach(data: [.light, .medium, .heavy] as [UIImpactFeedbackGenerator.FeedbackStyle]) {
          style in
          BookNodePreview {
            InteractiveNode(
              animation: .translucent,
              haptics: .impactOnTouchUpInside(style: style)
            ) {
              makeBody()
            }
          }
          .title("Impact style:\(style.localizedDescription)")
        }

        if #available(iOS 13, *) {

          BookForEach(data: [.soft, .rigid] as [UIImpactFeedbackGenerator.FeedbackStyle]) {
            style in
            BookNodePreview {
              InteractiveNode(
                animation: .translucent,
                haptics: .impactOnTouchUpInside(style: style)
              ) {
                makeBody()
              }
            }
            .title("Impact style:\(style.localizedDescription)")
          }

        }
      }

    }
  }
}

extension UIImpactFeedbackGenerator.FeedbackStyle {

  fileprivate var localizedDescription: String {
    switch self {
    case .light:
      return "light"
    case .medium:
      return "medium"
    case .heavy:
      return "heavy"
    case .soft:
      return "soft"
    case .rigid:
      return "rigid"
    @unknown default:
      return "unknown"
    }
  }

}
