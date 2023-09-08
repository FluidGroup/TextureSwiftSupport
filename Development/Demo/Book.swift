import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

@MainActor
let book = Book(title: "TextureSwiftSupport") {

  Book.bookImageNode()

  Book.hStackLayout()

  Book.bookInteractiveNode()
  Book.bookStyledEdgeNode()

  Book.tiledLayer()

  Book.layerBacked()

  BookPage(title: "Transition") {
    BookPush(title: "push") {
      TransitionLayoutViewController()
    }
  }

  BookPage(title: "Instagram post") {
    BookPush(title: "push") {
      InstagramPostCellViewController()
    }
  }
  BookPage(title: "Adaptive layoutt") {
    BookPush(title: "push") {
      AdaptiveLayoutViewController()
    }
  }

  BookPage(title: "Composition") {
    BookPush(title: "push") {
      CompositionCatalogViewController()
    }
  }

  BookPage(title: "Test recursive layout") {
    BookPush(title: "Push") {
      RecursiveLayoutViewController()
    }
  }

}
