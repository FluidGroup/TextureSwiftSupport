import AsyncDisplayKit
import GlossButtonNode
import TextureSwiftSupport
import TypedTextAttributes
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

extension GlossButtonNode {

  static func simpleButton(title: String, onTap: @escaping () -> Void) -> GlossButtonNode {

    let button = GlossButtonNode()
    button.onTap = onTap
    button.setDescriptor(
      .init(
        title: title.attributed {
          TextAttributes()
            .font(.preferredFont(forTextStyle: .headline))
            .foregroundColor(.black)
        },
        image: nil,
        bodyStyle: .init(
          layout: .horizontal(
            imageEdgeInsets: .init(top: 0, left: 0, bottom: 0, right: 4)
          ),
          highlightAnimation: .basic
        ),
        surfaceStyle: .fill(
          .init(cornerRound: nil, backgroundColor: nil, dropShadow: nil)
        ),
        bodyOpacity: 1,
        insets: .init(top: 10, left: 16, bottom: 10, right: 16),
        indicatorViewStyle: .gray
      ),
      for: .normal
    )
    return button

  }
}
