
///
/// - Author: TetureSwiftSupport
public struct AspectRatioLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {

  public let content: Content
  public let ratio: CGFloat

  public init(ratio: CGFloat, content: () -> Content) {
    self.ratio = ratio
    self.content = content()
  }

  public init(ratio: CGSize, content: () -> Content) {
    self.ratio = ratio.height / ratio.width
    self.content = content()
  }

  public func tss_make() -> [ASLayoutElement] {
    [
      ASRatioLayoutSpec(ratio: ratio, child: content.tss_make().first!)
    ]
  }

}
