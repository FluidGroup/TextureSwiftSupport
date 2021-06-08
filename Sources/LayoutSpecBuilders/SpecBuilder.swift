import AsyncDisplayKit

public protocol _ASLayoutElementType {

  /// For TextureSwiftSupport
  func tss_make() -> [ASLayoutElement]
}

extension _ASLayoutElementType {
  public func modifier<Modifier: ModifierType>(
    _ modifier: Modifier
  ) -> ModifiedContent<Self, Modifier> {
    ModifiedContent(content: self, modifier: modifier)
  }
}

extension Array: _ASLayoutElementType where Element: _ASLayoutElementType {

  public func tss_make() -> [ASLayoutElement] {
    self.flatMap {
      $0.tss_make()
    }
  }

}

///
/// - Author: TetureSwiftSupport
public struct ModifiedContent<Content: _ASLayoutElementType, Modifier: ModifierType>:
  _ASLayoutElementType
{

  let content: Content
  var modifier: Modifier

  init(
    content: Content,
    modifier: Modifier
  ) {
    self.content = content
    self.modifier = modifier
  }

  public func tss_make() -> [ASLayoutElement] {

    content.tss_make().map {
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

  public init(
    _ modify: @escaping (ASLayoutElement) -> ASLayoutElement
  ) {
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

  public static func buildBlock<Content>(_ content: Content) -> Content
  where Content: _ASLayoutElementType {
    content
  }

  @_disfavoredOverload
  public static func buildBlock(_ content: _ASLayoutElementType...) -> MultiLayout {
    MultiLayout(content)
  }

  @_disfavoredOverload
  public static func buildBlock(_ content: _ASLayoutElementType?...) -> MultiLayout {
    MultiLayout(content.compactMap { $0 })
  }

  public static func buildIf<Content: _ASLayoutElementType>(
    _ content: Content?
  ) -> OptionalLayout<Content> {
    return .init(content: { content })
  }

  public static func buildEither<TrueContent, FalseContent>(
    first: TrueContent
  ) -> ConditionalLayout<TrueContent, FalseContent> {
    .init(trueContent: first)
  }

  public static func buildEither<TrueContent, FalseContent>(
    second: FalseContent
  ) -> ConditionalLayout<TrueContent, FalseContent> {
    .init(falseContent: second)
  }

  public static func buildExpression<Content: _ASLayoutElementType>(
    _ expression: Content
  ) -> Content {
    return expression
  }

  public static func buildExpression<Content: _ASLayoutElementType>(
    _ expression: Content?
  ) -> OptionalLayout<Content> {
    return .init(content: { expression })
  }

}

extension ASDisplayNode: _ASLayoutElementType {
  ///
  /// - Author: TetureSwiftSupport
  public func tss_make() -> [ASLayoutElement] {
    [self]
  }
}

extension ASLayoutSpec: _ASLayoutElementType {
  ///
  /// - Author: TetureSwiftSupport
  public func tss_make() -> [ASLayoutElement] {
    [self]
  }
}

extension Optional: _ASLayoutElementType where Wrapped: _ASLayoutElementType {

  public func tss_make() -> [ASLayoutElement] {
    map { $0.tss_make() } ?? []
  }
}

/// A layout spec that is entry point to describe layout DSL
///
/// - Author: TetureSwiftSupport
public class LayoutSpec<Content>: ASWrapperLayoutSpec where Content: _ASLayoutElementType {

  public init(
    @ASLayoutSpecBuilder _ content: () -> Content
  ) {
    super.init(layoutElements: content().tss_make())
  }
}

/// A layout spec that is entry point to describe layout DSL
///
/// - Author: TetureSwiftSupport
public final class AnyLayoutSpec: ASWrapperLayoutSpec {

  public init<Content: _ASLayoutElementType>(
    @ASLayoutSpecBuilder _ content: () -> Content
  ) {
    super.init(layoutElements: content().tss_make())
  }

}
