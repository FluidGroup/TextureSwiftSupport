import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

let book = Book(title: "TextureSwiftSupport") {

  BookNavigationLink(title: "Components") {
    Book.bookInteractiveNode()
  }

  BookPush(title: "Transition") {
    TransitionLayoutViewController()
  }

  BookPush(title: "Instagram post") {
    InstagramPostCellViewController()
  }

  BookPush(title: "Adaptive layout") {
    AdaptiveLayoutViewController()
  }

  BookPush(title: "Composition") {
    CompositionCatalogViewController()
  }

  BookPush(title: "Test recursive layout") {
    RecursiveLayoutViewController()
  }
}
