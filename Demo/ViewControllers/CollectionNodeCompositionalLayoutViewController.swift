import AsyncDisplayKit
import TextureSwiftSupport

@available(iOS 13, *)
final class CollectionNodeCompositionalLayoutViewController: DisplayNodeViewController, ASCollectionDataSource {

  let collectionNode: ASCollectionNode

  override init() {

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(1)
      ),
      subitems: [
        NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
          )
        )
      ]
    )

    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout.init(section: section)

    self.collectionNode = .init(frame: .zero, collectionViewLayout: layout)

    super.init()
    
    self.collectionNode.layoutInspector
    self.collectionNode.dataSource = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return 1
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return 30
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    return {
      Self.makeCell()
    }
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      collectionNode
    }
  }

  static func makeCell() -> ASCellNode {

    let label = ASTextNode()
    label.attributedText = "Hello".styled(.init())

    return WrapperCellNode(
      content: AnyDisplayNode { _, _ in
        LayoutSpec {
          label
            .padding(10)
        }
      }
    )

  }
}
