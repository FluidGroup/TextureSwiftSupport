import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

extension Book {

  static func makeBox() -> ASDisplayNode {
    ShapeLayerNode
      .roundedCorner(radius: 0)
      .setShapeFillColor(.systemYellow)
      .setShapeLineWidth(3)
      .setStrokeColor(.init(white: 0, alpha: 0.2))
  }

  static func hStackLayout() -> BookView {

    BookNavigationLink(title: "HStackLayout") {

      BookForEach(data: [.start, .center, .end, .spaceBetween, .spaceAround] as [ASStackLayoutJustifyContent]) { justifyContent in

        BookNodePreview(expandsWidth: true) {
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
        .title("\(justifyContent.rawValue)")
      }

      BookForEach(data: [.start, .center, .end, .spaceBetween, .spaceAround] as [ASStackLayoutJustifyContent]) { justifyContent in

        BookNodePreview(expandsWidth: false) {
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
        .title("\(justifyContent.rawValue)")
      }

    }

  }
}
