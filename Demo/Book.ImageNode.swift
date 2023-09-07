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
  static func bookImageNode() -> BookPage {

    BookPage(title: "ASImageNode") {
      BookSection(title: "ContentMode - .center") {
        BookNodePreview { _ in
          let node = Self.makeImageNode()
          node.contentMode = .center
          return node
        }
        .frame(maxWidth: .greatestFiniteMagnitude)

        BookNodePreview(title: "Width: 60") { _ in
          let node = Self.makeImageNode()
          node.contentMode = .center
          node.style.maxWidth = .init(unit: .points, value: 60)
          return node
        }
        .frame(maxWidth: .greatestFiniteMagnitude)

        BookNodePreview(title: "Width: 200") { _ in
          let node = Self.makeImageNode()
          node.contentMode = .center
          node.style.maxWidth = .init(unit: .points, value: 200)
          return node
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
      }

      BookSection(title: "ContentMode - .scaleAspectFit") {
        BookNodePreview { _ in
          let node = Self.makeImageNode()
          node.contentMode = .scaleAspectFit
          return node
        }
        .frame(maxWidth: .greatestFiniteMagnitude)

        BookNodePreview { _ in
          let node = Self.makeImageNode()
          node.contentMode = .scaleAspectFit
          node.style.maxWidth = .init(unit: .points, value: 60)
          return node
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
      }
    }

  }

}
