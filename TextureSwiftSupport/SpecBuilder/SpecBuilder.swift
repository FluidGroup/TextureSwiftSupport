import AsyncDisplayKit

public protocol _ASLayoutElementType {
  
  func make() -> [ASLayoutElement]
}

extension _ASLayoutElementType {
  public func modifier<Modifier: ModifierType>(_ modifier: Modifier) -> ModifiedContent<Self, Modifier> {
    ModifiedContent(content: self, modifier: modifier)
  }
}

extension Array: _ASLayoutElementType where Element: _ASLayoutElementType {
  
  public func make() -> [ASLayoutElement] {
    self.flatMap {
      $0.make()
    }
  }
  
}

///
/// - Author: TetureSwiftSupport
public struct ModifiedContent<Content: _ASLayoutElementType, Modifier: ModifierType>: _ASLayoutElementType {
  
  let content: Content
  var modifier: Modifier
  
  init(content: Content, modifier: Modifier) {
    self.content = content
    self.modifier = modifier
  }
  
  public func make() -> [ASLayoutElement] {
    
    content.make().map {
      modifier.modify(element: $0)
    }
        
  }
    
}

///
/// - Author: TetureSwiftSupport
public protocol ModifierType {
  func modify(element: ASLayoutElement) -> ASLayoutElement
}

///
/// - Author: TetureSwiftSupport
public struct Modifier: ModifierType {
    
  private let _modify: (ASLayoutElement) -> ASLayoutElement
  
  public init(_ modify: @escaping (ASLayoutElement) -> ASLayoutElement) {
    self._modify = modify
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    _modify(element)
  }
}

///
/// - Author: TetureSwiftSupport
@_functionBuilder public struct ASLayoutSpecBuilder {
  
  public static func buildBlock() -> EmptyLayout {
    EmptyLayout()
  }
  
  public static func buildBlock<Content>(_ content: Content) -> Content where Content : _ASLayoutElementType {
    content
  }

  @_disfavoredOverload
  public static func buildBlock(_ content: _ASLayoutElementType?...) -> MultiLayout {
    MultiLayout(content.compactMap { $0 })
  }

  @_disfavoredOverload
  public static func buildBlock<C: Collection>(_ contents: C) -> MultiLayout where C.Element : _ASLayoutElementType {
    MultiLayout(Array(contents))
  }

  public static func buildIf<Content>(_ content: Content?) -> Content? where Content : _ASLayoutElementType  {
    content
  }
  
  public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> ConditionalLayout<TrueContent, FalseContent> {
    .init(trueContent: first)
  }
  
  public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> ConditionalLayout<TrueContent, FalseContent> {
    .init(falseContent: second)
  }
}

extension ASDisplayNode : _ASLayoutElementType {
  ///
  /// - Author: TetureSwiftSupport
  public func make() -> [ASLayoutElement] {
    [self]
  }
}

extension ASLayoutSpec : _ASLayoutElementType {
  ///
  /// - Author: TetureSwiftSupport
  public func make() -> [ASLayoutElement] {
    [self]
  }
}

extension Optional: _ASLayoutElementType where Wrapped : _ASLayoutElementType {

  public func make() -> [ASLayoutElement] {
    map { $0.make() } ?? []
  }
}

///
/// - Author: TetureSwiftSupport
public struct ConditionalLayout<TrueContent, FalseContent> : _ASLayoutElementType where TrueContent : _ASLayoutElementType, FalseContent : _ASLayoutElementType {
  
  let content: [ASLayoutElement]
  
  init(trueContent: TrueContent) {
    self.content = trueContent.make()
  }
  
  init(falseContent: FalseContent) {
    self.content = falseContent.make()
  }
  
  public func make() -> [ASLayoutElement] {
    content
  }
}

///
/// - Author: TetureSwiftSupport
public final class LayoutSpec<Content> : ASWrapperLayoutSpec where Content : _ASLayoutElementType {
  
  public init(@ASLayoutSpecBuilder _ content: () -> Content) {
    super.init(layoutElements: content().make())
  }
}

///
/// - Author: TetureSwiftSupport
public struct MultiLayout : _ASLayoutElementType {
  
  public let elements: [_ASLayoutElementType?]
  
  init(_ elements: [_ASLayoutElementType?]) {
    self.elements = elements
  }
  
  public func make() -> [ASLayoutElement] {
    elements.compactMap { $0 }.flatMap { $0.make() }
  }
}

///
/// - Author: TetureSwiftSupport
public struct AnyLayout : _ASLayoutElementType {
  
  public let content: _ASLayoutElementType?

  @available(*, deprecated, message: "Use init(_: ASLayoutElement?)")
  @_disfavoredOverload
  public init(_ element: () -> ASLayoutElement?) {
    if let element = element() {
      self.content = ASWrapperLayoutSpec(layoutElement: element)
    } else {
      self.content = ASLayoutSpec()
    }
  }

  @available(*, deprecated, message: "Use init(_: _ASLayoutElementType)")
  public init(_ content: () -> _ASLayoutElementType) {
    self.content = content()
  }

  @_disfavoredOverload
  public init(_ element: ASLayoutElement?) {
    if let element = element {
      self.content = ASWrapperLayoutSpec(layoutElement: element)
    } else {
      self.content = ASLayoutSpec()
    }
  }

  public init(_ content: _ASLayoutElementType?) {
    self.content = content
  }
  
  public func make() -> [ASLayoutElement] {
    content?.make() ?? []
  }
}

///
/// - Author: TetureSwiftSupport
public struct EmptyLayout : _ASLayoutElementType {
  
  public init() {
    
  }
  
  public func make() -> [ASLayoutElement] {
    [ASLayoutSpec()]
  }
}

public struct OptionalLayout<Content: _ASLayoutElementType> : _ASLayoutElementType {
  
  private let content: Content?
  
  public init(content: () -> Content?) {
    self.content = content()
  }
  
  public func make() -> [ASLayoutElement] {
    content?.make() ?? []
  }
}

///
/// - Author: TetureSwiftSupport
public enum FlexWrap {
  case wrap(lineSpacing: CGFloat = 0, alignContent: ASStackLayoutAlignContent = .start)
  case noWrap
}

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
  
  public func make() -> [ASLayoutElement] {
    
    let spec = ASStackLayoutSpec(
      direction: .vertical,
      spacing: spacing,
      justifyContent: justifyContent,
      alignItems: alignItems,
      children: children.make()
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

///
/// - Author: TetureSwiftSupport
public struct HStackLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {
  
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
  
  public func make() -> [ASLayoutElement] {
    
    let spec = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: spacing,
      justifyContent: justifyContent,
      alignItems: alignItems,
      children: children.make()
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

///
/// - Author: TetureSwiftSupport
public struct ZStackLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {
  
  public let children: Content
  
  public init(
    @ASLayoutSpecBuilder content: () -> Content
  ) {
    self.children = content()
  }
  
  public func make() -> [ASLayoutElement] {
    [
      ASWrapperLayoutSpec(layoutElements: children.make())
    ]
  }
}

///
/// - Author: TetureSwiftSupport
public struct WrapperLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {
  
  public let child: Content
  
  public init(
    content: () -> Content
  ) {
    self.child = content()
  }
  
  public func make() -> [ASLayoutElement] {
    [
      ASWrapperLayoutSpec(layoutElements: child.make())
    ]
  }
}

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
  
  public func make() -> [ASLayoutElement] {
    content.make().map {
      ASCenterLayoutSpec(
        centeringOptions: centeringOptions,
        sizingOptions: sizingOptions,
        child: $0
      )
    }
  }
}

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

  public func make() -> [ASLayoutElement] {
    content.make().map {
      ASRelativeLayoutSpec(
        horizontalPosition: horizontalPosition,
        verticalPosition: verticalPosition,
        sizingOption: sizingOption,
        child: $0
      )
    }
  }
}

///
/// - Author: TetureSwiftSupport
public struct InsetLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {
  
  public let content: Content
  public var insets: UIEdgeInsets
  
  public init(insets: UIEdgeInsets, content: () -> Content) {
    self.content = content()
    self.insets = insets
  }
  
  public func make() -> [ASLayoutElement] {
    content.make().map { ASInsetLayoutSpec(insets: insets, child: $0) }
  }
}

///
/// - Author: TetureSwiftSupport
public struct OverlayLayout<OverlayContnt, Content> : _ASLayoutElementType where OverlayContnt : _ASLayoutElementType, Content : _ASLayoutElementType {
  
  public let content: Content
  public let overlay: OverlayContnt
  
  public init(content: () -> Content, overlay: () -> OverlayContnt) {
    self.content = content()
    self.overlay = overlay()
  }
  
  public func make() -> [ASLayoutElement] {
    [
      ASOverlayLayoutSpec(child: content.make().first!, overlay: overlay.make().first!)
    ]
  }
  
}

///
/// - Author: TetureSwiftSupport
public struct BackgroundLayout<BackgroundContnt, Content> : _ASLayoutElementType where BackgroundContnt : _ASLayoutElementType, Content : _ASLayoutElementType {
  
  public let content: Content
  public let background: BackgroundContnt
  
  public init(content: () -> Content, background: () -> BackgroundContnt) {
    self.content = content()
    self.background = background()
  }
  
  public func make() -> [ASLayoutElement] {
    [
      ASBackgroundLayoutSpec(child: content.make().first!, background: background.make().first!)
    ]
  }
  
}

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
  
  public func make() -> [ASLayoutElement] {
    [
      ASRatioLayoutSpec(ratio: ratio, child: content.make().first!)
    ]
  }
  
}

///
/// - Author: TetureSwiftSupport
public struct SpacerLayout : _ASLayoutElementType {

  public let minLength: CGFloat
  public let flexGrow: CGFloat

  public init(minLength: CGFloat = 0, flexGrow: CGFloat = 1) {
    self.minLength = minLength
    self.flexGrow = flexGrow
  }

  public func make() -> [ASLayoutElement] {
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

///
/// - Author: TetureSwiftSupport
public struct HSpacerLayout : _ASLayoutElementType {
  
  public let minLength: CGFloat
    
  public init(minLength: CGFloat = 0) {
    self.minLength = minLength
  }
    
  public func make() -> [ASLayoutElement] {
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
public struct VSpacerLayout : _ASLayoutElementType {
  
  public let minLength: CGFloat
  
  public init(minLength: CGFloat = 0) {
    self.minLength = minLength
  }
  
  public func make() -> [ASLayoutElement] {
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
