import AsyncDisplayKit

public protocol _ASLayoutElementType {
  
  func make() -> [ASLayoutElement]
}

@_functionBuilder public struct ASLayoutSpecBuilder {
  
  public static func buildBlock() -> AS.EmptyLayout {
    AS.EmptyLayout()
  }
  
  public static func buildBlock<Content>(_ content: Content) -> Content where Content : _ASLayoutElementType {
    content
  }
  
  public static func buildBlock(_ content: _ASLayoutElementType...) -> AS.MultiLayout {
    AS.MultiLayout(content)
  }
  
  public static func buildIf<Content>(_ content: Content?) -> Content? where Content : _ASLayoutElementType  {
    content
  }
  
  public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> ASConditionalLayout<TrueContent, FalseContent> {
    .init(trueContent: first)
  }
  
  public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> ASConditionalLayout<TrueContent, FalseContent> {
    .init(falseContent: second)
  }
}

extension ASDisplayNode : _ASLayoutElementType {
  public func make() -> [ASLayoutElement] {
    [self]
  }
}

public struct ASConditionalLayout<TrueContent, FalseContent> : _ASLayoutElementType where TrueContent : _ASLayoutElementType, FalseContent : _ASLayoutElementType {
  
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

public enum AS {
  
  public final class LayoutSpec<Content> : ASWrapperLayoutSpec where Content : _ASLayoutElementType {
    
    public init(@ASLayoutSpecBuilder _ content: () -> Content) {
      super.init(layoutElements: content().make())
    }
  }
  
  public struct MultiLayout : _ASLayoutElementType {
    
    public let elements: [_ASLayoutElementType?]
    
    init(_ elements: [_ASLayoutElementType?]) {
      self.elements = elements
    }
    
    public func make() -> [ASLayoutElement] {
      elements.compactMap { $0 }.flatMap { $0.make() }
    }
  }
  
  public struct EmptyLayout : _ASLayoutElementType {
    
    public func make() -> [ASLayoutElement] {
      [ASLayoutSpec()]
    }
  }
  
  public struct VStack<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {
    
    public let spacing: CGFloat
    public let justifyContent: ASStackLayoutJustifyContent
    public let alignItems: ASStackLayoutAlignItems
    public let childlen: Content
    
    public init(
      spacing: CGFloat = 0,
      justifyContent: ASStackLayoutJustifyContent = .start,
      alignItems: ASStackLayoutAlignItems = .start,
      @ASLayoutSpecBuilder content: () -> Content
      ) {
      
      self.spacing = spacing
      self.justifyContent = justifyContent
      self.alignItems = alignItems
      self.childlen = content()
      
    }
    
    public func make() -> [ASLayoutElement] {
      [
        ASStackLayoutSpec(
          direction: .vertical,
          spacing: spacing,
          justifyContent: justifyContent,
          alignItems: alignItems,
          children: childlen.make()
        )
      ]
    }
  }
  
  public struct HStack<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {
    
    public let spacing: CGFloat
    public let justifyContent: ASStackLayoutJustifyContent
    public let alignItems: ASStackLayoutAlignItems
    public let childlen: Content
    
    public init(
      spacing: CGFloat = 0,
      justifyContent: ASStackLayoutJustifyContent = .start,
      alignItems: ASStackLayoutAlignItems = .start,
      @ASLayoutSpecBuilder content: () -> Content
      ) {
      
      self.spacing = spacing
      self.justifyContent = justifyContent
      self.alignItems = alignItems
      self.childlen = content()
      
    }
    
    public func make() -> [ASLayoutElement] {
      [
        ASStackLayoutSpec(
          direction: .horizontal,
          spacing: spacing,
          justifyContent: justifyContent,
          alignItems: alignItems,
          children: childlen.make()
        )
      ]
    }
    
  }
  
  public struct Inset<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {
    
    public let content: Content
    public let insets: UIEdgeInsets
    
    public init(insets: UIEdgeInsets, content: () -> Content) {
      self.content = content()
      self.insets = insets
    }
    
    public func make() -> [ASLayoutElement] {
      content.make().map { ASInsetLayoutSpec(insets: insets, child: $0) }
    }
  }
  
  public struct Overlay<OverlayContnt, Content> : _ASLayoutElementType where OverlayContnt : _ASLayoutElementType, Content : _ASLayoutElementType {
    
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

  public struct Background<BackgroundContnt, Content> : _ASLayoutElementType where BackgroundContnt : _ASLayoutElementType, Content : _ASLayoutElementType {
    
    public let content: Content
    public let background: BackgroundContnt
    
    public init(content: () -> Content, overlay: () -> BackgroundContnt) {
      self.content = content()
      self.background = overlay()
    }
    
    public func make() -> [ASLayoutElement] {
      [
        ASBackgroundLayoutSpec(child: content.make().first!, background: background.make().first!)
      ]
    }
    
  }
  
}
