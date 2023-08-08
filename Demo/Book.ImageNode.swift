import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

extension Book {

  private static func makeImageNode() -> ASImageNode {
    let node = ASImageNode()
    node.image = UIImage(named: "image")
    return node
  }

  @MainActor
  static func bookImageNode() -> BookView {

    BookNavigationLink(title: "ImageNode") {

      BookPage(title: "ASImageNode") {
        BookSection(title: "ContentMode - .center") {
          BookNodePreview(expandsWidth: true) {
            let node = Self.makeImageNode()
            node.contentMode = .center
            return node
          }

          BookNodePreview(expandsWidth: true) {
            let node = Self.makeImageNode()
            node.contentMode = .center
            node.style.maxWidth = .init(unit: .points, value: 60)
            return node
          }
          .title("Width: 60")

          BookNodePreview(expandsWidth: true) {
            let node = Self.makeImageNode()
            node.contentMode = .center
            node.style.maxWidth = .init(unit: .points, value: 200)
            return node
          }
          .title("Width: 200")
        }

        BookSection(title: "ContentMode - .scaleAspectFit") {
          BookNodePreview(expandsWidth: true) {
            let node = Self.makeImageNode()
            node.contentMode = .scaleAspectFit
            return node
          }

          BookNodePreview(expandsWidth: true) {
            let node = Self.makeImageNode()
            node.contentMode = .scaleAspectFit
            node.style.maxWidth = .init(unit: .points, value: 60)
            return node
          }
        }
      }

    }

  }

}
