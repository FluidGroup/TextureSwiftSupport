///
/// - Author: TetureSwiftSupport
public struct OverlayLayout<OverlayContnt, Content> : _ASLayoutElementType where OverlayContnt : _ASLayoutElementType, Content : _ASLayoutElementType {

  public let content: Content
  public let overlay: OverlayContnt

  public init(content: () -> Content, overlay: () -> OverlayContnt) {
    self.content = content()
    self.overlay = overlay()
  }

  public func tss_make() -> [ASLayoutElement] {
    [
      ASOverlayLayoutSpec(
        child: content.tss_make().first!,
        overlay: overlay.tss_make().first ?? ASLayoutSpec()
      )
    ]
  }

}
