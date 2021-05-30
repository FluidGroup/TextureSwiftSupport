
import StorybookKit

let book = Book(title: "TextureSwiftSupport") {
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
