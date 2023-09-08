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
  static func bookInteractiveNode() -> BookPage {
    BookPage(title: "InteractiveNode") {
      BookNodePreview { _ in
        InteractiveNode(animation: .translucent) {
          makeBody()
        }
      }

      BookSection(title: "With Haptics") {

        ForEach.inefficient(items: [.light, .medium, .heavy] as [UIImpactFeedbackGenerator.FeedbackStyle]) {
          style in
          BookNodePreview(title: "Impact style:\(style.localizedDescription)") { _ in
            InteractiveNode(
              animation: .translucent,
              haptics: .impactOnTouchUpInside(style: style)
            ) {
              makeBody()
            }
          }
        }

        if #available(iOS 13, *) {

          ForEach.inefficient(items: [.soft, .rigid] as [UIImpactFeedbackGenerator.FeedbackStyle]) {
            style in
            BookNodePreview(title: "Impact style:\(style.localizedDescription)") { _ in
              InteractiveNode(
                animation: .translucent,
                haptics: .impactOnTouchUpInside(style: style)
              ) {
                makeBody()
              }
            }
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
