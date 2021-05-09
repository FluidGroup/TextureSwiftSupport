
///
/// - Author: TetureSwiftSupport
@available(*, deprecated, message: "Use SpacerLayout instead")
public struct HSpacerLayout : _ASLayoutElementType {

  public let minLength: CGFloat

  public init(minLength: CGFloat = 0) {
    self.minLength = minLength
  }

  public func tss_make() -> [ASLayoutElement] {
    [
      {
        let spec = ASLayoutSpec()
        spec.style.flexGrow = 1
        spec.style.minWidth = .init(unit: .points, value: minLength)
        return spec
      }()
    ]
  }
}

///
/// - Author: TetureSwiftSupport
@available(*, deprecated, message: "Use SpacerLayout instead")
public struct VSpacerLayout : _ASLayoutElementType {

  public let minLength: CGFloat

  public init(minLength: CGFloat = 0) {
    self.minLength = minLength
  }

  public func tss_make() -> [ASLayoutElement] {
    [
      {
        let spec = ASLayoutSpec()
        spec.style.flexGrow = 1
        spec.style.minHeight = .init(unit: .points, value: minLength)
        return spec
      }()
    ]
  }
}

