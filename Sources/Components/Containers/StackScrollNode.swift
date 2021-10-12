
import Foundation

import AsyncDisplayKit

/// Backing Component is ASCollectionNode
open class StackScrollNode : NamedDisplayNodeBase, ASCollectionDelegate, ASCollectionDataSource {

  public final var onScrollViewDidScroll: (UIScrollView) -> Void = { _ in }

  open var shouldWaitUntilAllUpdatesAreCommitted: Bool = false

  open var isScrollEnabled: Bool {
    get {
      return collectionNode.view.isScrollEnabled
    }
    set {
      collectionNode.view.isScrollEnabled = newValue
    }
  }

  open var scrollView: UIScrollView {
    return collectionNode.view
  }

  open var collectionViewLayout: UICollectionViewFlowLayout {
    return collectionNode.view.collectionViewLayout as! UICollectionViewFlowLayout
  }

  open private(set) var nodes: [ASCellNode] = []

  /// It should not be accessed unless there is special.
  internal let collectionNode: ASCollectionNode

  public init(layout: UICollectionViewFlowLayout) {

    collectionNode = ASCollectionNode(collectionViewLayout: layout)
    collectionNode.backgroundColor = .clear

    super.init()
  }

  public convenience init(
    scrollDirection: UICollectionView.ScrollDirection,
    spacing: CGFloat,
    sectionInset: UIEdgeInsets
  ) {

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = scrollDirection
    layout.minimumLineSpacing = spacing
    layout.sectionInset = sectionInset

    self.init(layout: layout)
  }

  public override convenience init() {

    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = .zero

    self.init(layout: layout)
  }

  open func append(nodes: [ASCellNode]) {

    self.nodes += nodes

    collectionNode.reloadData()
    if shouldWaitUntilAllUpdatesAreCommitted {
      collectionNode.waitUntilAllUpdatesAreProcessed()
    }
  }

  open func removeAll() {
    self.nodes = []

    collectionNode.reloadData()
    if shouldWaitUntilAllUpdatesAreCommitted {
      collectionNode.waitUntilAllUpdatesAreProcessed()
    }
  }

  open func replaceAll(nodes: [ASCellNode]) {

    self.nodes = nodes

    collectionNode.reloadData()
    if shouldWaitUntilAllUpdatesAreCommitted {
      collectionNode.waitUntilAllUpdatesAreProcessed()
    }
  }

  open override func didLoad() {

    super.didLoad()

    addSubnode(collectionNode)

    collectionNode.delegate = self
    collectionNode.dataSource = self

    switch collectionViewLayout.scrollDirection {
    case .vertical:
      collectionNode.view.alwaysBounceVertical = true
    case .horizontal:
      collectionNode.view.alwaysBounceHorizontal = true
    @unknown default:
      assertionFailure()
    }

  }

  open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    return ASWrapperLayoutSpec(layoutElement: collectionNode)
  }

  // MARK: - ASCollectionDelegate

  public func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {

    switch collectionViewLayout.scrollDirection {
    case .vertical:

      return ASSizeRange(
        min: .init(width: collectionNode.bounds.width, height: 0),
        max: .init(width: collectionNode.bounds.width, height: .infinity)
      )

    case .horizontal:

      return ASSizeRange(
        min: .init(width: 0, height: collectionNode.bounds.height),
        max: .init(width: .infinity, height: collectionNode.bounds.height)
      )

    @unknown default:
      fatalError()
    }
  }

  // MARK: - ASCollectionDataSource
  open var numberOfSections: Int {
    return 1
  }

  public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {

    return nodes.count
  }

  public func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
    return nodes[indexPath.item]
  }

  // MARK: - UIScrollViewDelegate
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    onScrollViewDidScroll(scrollView)
  }
}

