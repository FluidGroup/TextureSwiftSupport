///
/// - Author: TetureSwiftSupport
public struct WrapperLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {

  public let child: Content

  public init(
    content: () -> Content
  ) {
    self.child = content()
  }

  public func tss_make() -> [ASLayoutElement] {
    [
      ASWrapperLayoutSpec(layoutElements: child.tss_make())
    ]
  }
}
