///
/// - Author: TetureSwiftSupport
public struct AbsoluteLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {

  public let sizing: ASAbsoluteLayoutSpecSizing
  public let children: Content

  public init(
    sizing: ASAbsoluteLayoutSpecSizing = .default,
    @ASLayoutSpecBuilder content: () -> Content
  ) {
    self.sizing = sizing
    self.children = content()
  }

  public func tss_make() -> [ASLayoutElement] {
    [ASAbsoluteLayoutSpec(sizing: sizing, children: children.tss_make())]
  }
}

