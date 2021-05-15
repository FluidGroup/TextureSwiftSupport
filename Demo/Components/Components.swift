import AsyncDisplayKit
import TextureSwiftSupport
import UIKit

enum Components {

  static func makeSelectionCell(
    title: String,
    description: String? = nil,
    onTap: @escaping () -> Void
  ) -> ASCellNode {

    let shape = ShapeLayerNode.roundedCorner(radius: 8)

    let descriptionLabel = ASTextNode()
    descriptionLabel.attributedText = description.map {
      NSAttributedString(
        string: $0,
        attributes: [
          .font: UIFont.preferredFont(forTextStyle: .caption1),
          .foregroundColor: UIColor.lightGray,
        ]
      )
    }

    let label = ASTextNode()
    label.attributedText = NSAttributedString(
      string: title,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .subheadline),
        .foregroundColor: UIColor.darkGray,
      ]
    )

    return WrapperCellNode {
      return InteractiveNode(animation: .translucent) {
        return AnyDisplayNode { _, _ in

          LayoutSpec {
            VStackLayout(spacing: 8) {
              HStackLayout {
                label
                  .flexGrow(1)
              }
              if description != nil {
                descriptionLabel
              }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(shape)
            .padding(4)
          }
        }
        .onDidLoad { _ in
          shape.shapeFillColor = .init(white: 0.95, alpha: 1)
        }
      }
      .onTap {
        onTap()
      }
    }
  }

  static func makeWrapper(_ node: ASDisplayNode) -> ASCellNode {
    WrapperCellNode { node }
  }
}
