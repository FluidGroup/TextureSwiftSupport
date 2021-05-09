
///
/// - Author: TetureSwiftSupport
public struct SpacerLayout : _ASLayoutElementType {

  public let minLength: CGFloat
  public let flexGrow: CGFloat

  public init(minLength: CGFloat = 0, flexGrow: CGFloat = 1) {
    self.minLength = minLength
    self.flexGrow = flexGrow
  }

  public func tss_make() -> [ASLayoutElement] {
    [
      {
        let spec = ASLayoutSpec()
        spec.style.spacingBefore = minLength
        spec.style.flexGrow = flexGrow
        return spec
      }()
    ]
  }
}
