import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport
import SwiftUISupport

extension Book {

  static func makeBox() -> ASDisplayNode {
    ShapeLayerNode
      .roundedCorner(radius: 0)
      .setShapeFillColor(.systemYellow)
      .setShapeLineWidth(3)
      .setStrokeColor(.init(white: 0, alpha: 0.2))
  }

  @MainActor
  static func hStackLayout() -> BookPage {

    BookPage(title: "HStackLayout") {

      ForEach.inefficient(items: [.start, .center, .end, .spaceBetween, .spaceAround] as [ASStackLayoutJustifyContent]) { justifyContent in

        BookNodePreview(title: "\(justifyContent.rawValue)") { _ in
          AnyDisplayNode { _, _ in
            LayoutSpec {
              HStackLayout(spacing: 20, justifyContent: justifyContent) {
                makeBox()
                  .preferredSize(.init(width: 28, height: 28))

                makeBox()
                  .preferredSize(.init(width: 28, height: 28))

                makeBox()
                  .preferredSize(.init(width: 28, height: 28))
              }
              .background(
                ShapeLayerNode.roundedCorner(radius: 0)
                  .setShapeFillColor(.init(white: 0, alpha: 0.2))
              )
            }
          }

        }
        .frame(maxWidth: .greatestFiniteMagnitude)

      }

      ForEach.inefficient(items: [.start, .center, .end, .spaceBetween, .spaceAround] as [ASStackLayoutJustifyContent]) { justifyContent in

        BookNodePreview(title: "\(justifyContent.rawValue)") { _ in
          AnyDisplayNode { _, _ in
            LayoutSpec {
              HStackLayout(spacing: 20, justifyContent: justifyContent) {
                makeBox()
                  .preferredSize(.init(width: 28, height: 28))

                makeBox()
                  .preferredSize(.init(width: 28, height: 28))

                makeBox()
                  .preferredSize(.init(width: 28, height: 28))
              }
              .background(
                ShapeLayerNode.roundedCorner(radius: 0)
                  .setShapeFillColor(.init(white: 0, alpha: 0.2))
              )
            }
          }

        }
        .frame(maxWidth: .greatestFiniteMagnitude)

      }

    }

  }
}
