///
/// - Author: TetureSwiftSupport
public struct CenterLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {

  public let content: Content
  public let centeringOptions: ASCenterLayoutSpecCenteringOptions
  public let sizingOptions: ASCenterLayoutSpecSizingOptions

  public init(
    centeringOptions: ASCenterLayoutSpecCenteringOptions = .XY,
    sizingOptions: ASCenterLayoutSpecSizingOptions = .minimumXY,
    content: () -> Content
  ) {
    self.content = content()
    self.centeringOptions = centeringOptions
    self.sizingOptions = sizingOptions
  }

  public func tss_make() -> [ASLayoutElement] {
    content.tss_make().map {
      ASCenterLayoutSpec(
        centeringOptions: centeringOptions,
        sizingOptions: sizingOptions,
        child: $0
      )
    }
  }
}
