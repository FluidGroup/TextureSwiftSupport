import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

extension Book {

  @MainActor
  static func bookStyledEdgeNode() -> BookView {
    BookNavigationLink(title: "StyledEdgeNode") {
      BookNodePreview {
        let bodyNode = ASDisplayNode()
        bodyNode.backgroundColor = .red

        let node = StyledEdgeNode<ASDisplayNode>(
          cornerRadius: 16,
          cornerRoundingStrategy: .clip(assimilationColor: .init(white: 0.9, alpha: 1)),
          contentNode: bodyNode
        )

        node.style.preferredSize = .init(width: 60, height: 60)
        return node
      }
      .backgroundColor(.orange)

      BookNodePreview {
        let bodyNode = ASDisplayNode()
        bodyNode.backgroundColor = .red

        let node = StyledEdgeNode<ASDisplayNode>(
          cornerRadius: 16,
          cornerRoundingStrategy: .clip(assimilationColor: .init(white: 0.9, alpha: 1)),
          border: .init(width: 4, color: .blue),
          contentNode: bodyNode
        )

        node.style.preferredSize = .init(width: 60, height: 60)
        return node
      }
      .backgroundColor(.orange)

      BookNodePreview {
        let bodyNode = ASDisplayNode()
        bodyNode.backgroundColor = .red

        let node = StyledEdgeNode<ASDisplayNode>.init(
          cornerRadius: 16,
          cornerRoundingStrategy: .mask,
          border: .init(width: 4, color: .blue),
          contentNode: bodyNode
        )

        node.style.preferredSize = .init(width: 60, height: 60)
        return node
      }
      .backgroundColor(.orange)
      .title("Mask")

    }

  }

}
