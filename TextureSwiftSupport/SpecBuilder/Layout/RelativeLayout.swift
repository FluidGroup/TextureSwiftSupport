
///
/// - Author: TetureSwiftSupport
public struct RelativeLayout<Content>: _ASLayoutElementType where Content: _ASLayoutElementType {

  public let content: Content
  public let horizontalPosition: ASRelativeLayoutSpecPosition
  public let verticalPosition: ASRelativeLayoutSpecPosition
  public let sizingOption: ASRelativeLayoutSpecSizingOption

  public init(
    horizontalPosition: ASRelativeLayoutSpecPosition = .start,
    verticalPosition: ASRelativeLayoutSpecPosition = .start,
    sizingOption: ASRelativeLayoutSpecSizingOption = .minimumSize,
    content: () -> Content
  ) {
    self.content = content()
    self.horizontalPosition = horizontalPosition
    self.verticalPosition = verticalPosition
    self.sizingOption = sizingOption
  }

  public func tss_make() -> [ASLayoutElement] {
    content.tss_make().map {
      ASRelativeLayoutSpec(
        horizontalPosition: horizontalPosition,
        verticalPosition: verticalPosition,
        sizingOption: sizingOption,
        child: $0
      )
    }
  }
}

