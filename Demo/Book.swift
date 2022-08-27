import StorybookKit
import StorybookKitTextureSupport
import TextureSwiftSupport

let book = Book(title: "TextureSwiftSupport") {
  
  if #available(iOS 13, *) {    
    Book.hostingNode
    Book.hostingCellNode
  }

  BookNavigationLink(title: "Standard Components") {
    Book.bookImageNode()
  }

  BookNavigationLink(title: "Layout") {
    Book.hStackLayout()
  }

  BookNavigationLink(title: "Components") {
    Book.bookInteractiveNode()
    Book.bookStyledEdgeNode()
  }

  BookNavigationLink(title: "Lab") {
    Book.tiledLayer()
  }

  Book.layerBacked()
  
  if #available(iOS 13, *) {
    
    BookPush(title: "CompositionalLayout") {
      CollectionNodeCompositionalLayoutViewController()
    }
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
