
import SwiftUI
import AsyncDisplayKit
import TextureSwiftSupport

enum Preview_Node: PreviewProvider {

  private typealias TargetComponent = CustomNode

  static var previews: some View {

    Group {
      ViewHost(instantiated: NodeView(node: TargetComponent()))
    }

  }

}

private final class CustomNode: ASDisplayNode {

  private let textNode = ASTextNode()

  override func didLoad() {
    super.didLoad()
    backgroundColor = .red

    textNode.attributedText = NSAttributedString(string: "Hello")

    automaticallyManagesSubnodes = true
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      textNode
    }
  }

}

public struct ViewHost<ContentView: UIView>: UIViewRepresentable {

  private let contentView: ContentView
  private let _update: @MainActor (_ uiView: ContentView, _ context: Context) -> Void

  public init(
    instantiated: ContentView,
    update: @escaping @MainActor (_ uiView: ContentView, _ context: Context) -> Void = { _, _ in }
  ) {
    self.contentView = instantiated
    self._update = update
  }

  public func makeUIView(context: Context) -> ContentView {
    return contentView
  }

  public func updateUIView(_ uiView: ContentView, context: Context) {
    _update(uiView, context)
  }

}

import UIKit
import AsyncDisplayKit

open class NodeView<D: ASDisplayNode>: UIView {

  public var node: D {
    internalView.node
  }

  private let internalView: _InternalNodeView<D>

  /// Creates an instance
  /// - Parameters:
  ///   - node: a node that embedded
  ///   - expandsWidth: Boolean value that indicates whether the node always expands to maximum width in bounding rect.
  ///   - frame:
  public init(
    node: D,
    expandsWidth: Bool = false,
    frame: CGRect = .zero
  ) {

    let internalView = _InternalNodeView(
      node: node,
      expandsWidth: expandsWidth,
      frame: frame
    )
    self.internalView = internalView

    super.init(frame: frame)

    addSubview(internalView)
    internalView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      internalView.leftAnchor.constraint(equalTo: leftAnchor),
      internalView.rightAnchor.constraint(equalTo: rightAnchor),
      internalView.topAnchor.constraint(equalTo: topAnchor),
      internalView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func invalidateIntrinsicContentSize() {
    internalView.invalidateIntrinsicContentSize()
    super.invalidateIntrinsicContentSize()
  }

}

private final class _InternalNodeView<D: ASDisplayNode>: UILabel /* To use `textRect` method */ {

  // MARK: - Unavailable

  @available(*, unavailable)
  override var text: String? {
    didSet {}
  }

  @available(*, unavailable)
  override var font: UIFont! {
    didSet {}
  }

  @available(*, unavailable)
  override var textColor: UIColor! {
    didSet {}
  }

  @available(*, unavailable)
  override var shadowColor: UIColor? {
    didSet {}
  }

  @available(*, unavailable)
  override var shadowOffset: CGSize {
    didSet {}
  }

  @available(*, unavailable)
  override var textAlignment: NSTextAlignment {
    didSet {}
  }

  @available(*, unavailable)
  override var lineBreakMode: NSLineBreakMode {
    didSet {}
  }

  @available(*, unavailable)
  override var attributedText: NSAttributedString? {
    didSet {}
  }

  @available(*, unavailable)
  override var highlightedTextColor: UIColor? {
    didSet {}
  }

  @available(*, unavailable)
  override var isHighlighted: Bool {
    didSet {}
  }

  @available(*, unavailable)
  override var isEnabled: Bool {
    didSet {}
  }

  @available(*, unavailable)
  override var numberOfLines: Int {
    didSet {}
  }

  @available(*, unavailable)
  override var adjustsFontSizeToFitWidth: Bool {
    didSet {}
  }

  @available(*, unavailable)
  override var baselineAdjustment: UIBaselineAdjustment {
    didSet {}
  }

  @available(*, unavailable)
  override var minimumScaleFactor: CGFloat {
    didSet {}
  }

  @available(*, unavailable)
  override var allowsDefaultTighteningForTruncation: Bool {
    didSet {}
  }

  @available(*, unavailable)
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect)
  }

  @available(*, unavailable)
  override var preferredMaxLayoutWidth: CGFloat {
    didSet {}
  }

  // MARK: - Properties

  let node: D
  private let wrapper: WrapperNode
  private let delegateProxy = __InterfaceStateDelegateProxy()
  public let expandsWidth: Bool

  // MARK: - Initializers

  init(
    node: D,
    expandsWidth: Bool,
    frame: CGRect = .zero
  ) {

    self.node = node
    self.wrapper = .init(wrapped: node)
    self.expandsWidth = expandsWidth

    super.init(frame: frame)

    /// To call `textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int)`
    super.numberOfLines = 0
    isUserInteractionEnabled = true

    addSubnode(wrapper)
    wrapper.add(delegateProxy)

    delegateProxy.didLayoutBlock = { [weak self] in
      self?.invalidateIntrinsicContentSize()
    }

  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    node.remove(delegateProxy)
  }

  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {

    let validate: (_ value: CGFloat, _ fallback: CGFloat) -> CGFloat = { value, fallback in
      // To guard crash inside Texture
      guard ASPointsValidForSize(value) else {
        return fallback
      }
      return value
    }

    var range = ASSizeRangeUnconstrained

    range.max.width = validate(bounds.width, 10000)

    if expandsWidth {
      range.min.width = validate(bounds.width, 0)
    }

    let calculatedlayout = wrapper.calculateLayoutThatFits(range)
    //    let calculatedSize = wrapper.calculateSizeThatFits(range.max)
    //    Log.debug(.generic, "[CalculateSizeThatFits] size: \(range.max), layout: \(calculatedSize) node: \(node)")
    return CGRect(origin: .zero, size: calculatedlayout.size)
  }

  // MARK: - Functions

  override func layoutSubviews() {

    super.layoutSubviews()

    wrapper.frame = bounds
  }
}

private final class WrapperNode: ASDisplayNode {

  private let wrapped: ASDisplayNode

  init(wrapped: ASDisplayNode) {
    self.wrapped = wrapped
    super.init()
    addSubnode(wrapped)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASWrapperLayoutSpec(layoutElement: wrapped)
  }

}

private final class __InterfaceStateDelegateProxy: NSObject, ASInterfaceStateDelegate {

  var didLayoutBlock: (() -> Void)?

  @objc dynamic func interfaceStateDidChange(_ newState: ASInterfaceState, from oldState: ASInterfaceState) {

  }

  @objc dynamic func didEnterVisibleState() {

  }

  @objc dynamic func didExitVisibleState() {

  }

  func didEnterDisplayState() {

  }

  @objc dynamic func didExitDisplayState() {

  }

  @objc dynamic func didEnterPreloadState() {

  }

  @objc dynamic func didExitPreloadState() {

  }

  @objc dynamic func nodeDidLayout() {
    didLayoutBlock?()
  }

  @objc dynamic func nodeDidLoad() {

  }

  @objc dynamic func hierarchyDisplayDidFinish() {

  }

}
