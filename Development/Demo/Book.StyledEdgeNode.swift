import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

extension Book {

  @MainActor
  static func bookStyledEdgeNode() -> BookPage {
    BookPage(title: "StyledEdgeNode") {
      BookNodePreview { _ in
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
      .background(Color.orange)

      BookNodePreview { _ in
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
      .background(Color.orange)

      BookNodePreview(title: "Mask") { _ in
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
      .background(Color.orange)


    }

  }

}
