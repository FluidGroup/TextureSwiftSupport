
///
/// - Author: TetureSwiftSupport
public struct VStackLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {

  public let spacing: CGFloat
  public let justifyContent: ASStackLayoutJustifyContent
  public let alignItems: ASStackLayoutAlignItems
  public let children: Content
  public let flexWrap: FlexWrap
  public let isConcurrent: Bool

  public init(
    spacing: CGFloat = 0,
    justifyContent: ASStackLayoutJustifyContent = .start,
    alignItems: ASStackLayoutAlignItems = .stretch,
    flexWrap: FlexWrap = .noWrap,
    isConcurrent: Bool = false,
    @ASLayoutSpecBuilder content: () -> Content
  ) {

    self.spacing = spacing
    self.justifyContent = justifyContent
    self.alignItems = alignItems
    self.flexWrap = flexWrap
    self.isConcurrent = isConcurrent
    self.children = content()

  }

  public func tss_make() -> [ASLayoutElement] {

    let spec = ASStackLayoutSpec(
      direction: .vertical,
      spacing: spacing,
      justifyContent: justifyContent,
      alignItems: alignItems,
      children: children.tss_make()
    )

    spec.isConcurrent = isConcurrent

    switch flexWrap {
    case .noWrap:
      spec.flexWrap = .noWrap
    case .wrap(let lineSpacing, let alignContent):
      spec.flexWrap = .wrap
      spec.lineSpacing = lineSpacing
      spec.alignContent = alignContent
    }

    return [
      spec
    ]
  }
}
