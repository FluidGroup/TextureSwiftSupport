///
/// - Author: TetureSwiftSupport
public struct InsetLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {

  public let content: Content
  public var insets: UIEdgeInsets

  public init(insets: UIEdgeInsets, content: () -> Content) {
    self.content = content()
    self.insets = insets
  }

  public func tss_make() -> [ASLayoutElement] {
    content.tss_make().map { ASInsetLayoutSpec(insets: insets, child: $0) }
  }
}
