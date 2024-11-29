
import Foundation

import AsyncDisplayKit

/// Backing Component is ASCollectionNode
open class StackScrollNode:
  NamedDisplayNodeBase,
  @unchecked Sendable {

  public final var onScrollViewDidScroll: (UIScrollView) -> Void = { _ in }

  open var shouldWaitUntilAllUpdatesAreCommitted: Bool = false

  @MainActor
  open var isScrollEnabled: Bool {
    get {
      scrollView.isScrollEnabled
    }
    set {
      scrollView.isScrollEnabled = newValue
    }
  }

  @MainActor
  open var scrollView: UIScrollView {
    return collectionNode.view
  }

  @MainActor
  open var collectionViewLayout: UICollectionViewFlowLayout {
    return collectionNode.view.collectionViewLayout as! UICollectionViewFlowLayout
  }

  open private(set) var nodes: [ASCellNode] = []

  /// It should not be accessed unless there is special.
  internal let collectionNode: ASCollectionNode

  @MainActor
  public init(layout: UICollectionViewFlowLayout) {

    collectionNode = ASCollectionNode(collectionViewLayout: layout)
    collectionNode.backgroundColor = .clear
    self.collectionViewLayoutScrollDirection = layout.scrollDirection

    super.init()
  }

  @MainActor
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

  @MainActor
  static func makeCollectionViewFlowLayoutNode() -> StackScrollNode {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = .zero
    return .init(layout: layout)
  }

  @MainActor
  open func append(nodes: [ASCellNode]) {

    self.nodes += nodes

    collectionNode.reloadData()
    if shouldWaitUntilAllUpdatesAreCommitted {
      collectionNode.waitUntilAllUpdatesAreProcessed()
    }
  }

  @MainActor
  open func removeAll() {
    self.nodes = []

    collectionNode.reloadData()
    if shouldWaitUntilAllUpdatesAreCommitted {
      collectionNode.waitUntilAllUpdatesAreProcessed()
    }
  }

  @MainActor
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


  // Cache the value for BG thread access
  private var collectionViewLayoutScrollDirection:  UICollectionView.ScrollDirection
  // MARK: - ASCollectionDelegate

  public func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {

    switch collectionViewLayoutScrollDirection {
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
}

extension StackScrollNode: ASCollectionDelegate {
  // MARK: - UIScrollViewDelegate
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    onScrollViewDidScroll(scrollView)
  }
}

extension StackScrollNode: ASCollectionDataSource {
  // MARK: - ASCollectionDataSource
  @objc open var numberOfSections: Int {
    return 1
  }


  @objc public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    nodes.count
  }

  @objc public func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
    nodes[indexPath.item]
  }
}
