import AsyncDisplayKit
import Descriptors

/**
 Provides highlighting function without tap handling for CollectionView.
 */
open class HighlightCellNode<D: ASDisplayNode>: NamedDisplayCellNodeBase {

  public typealias BodyNode = D

  open override var supportsLayerBacking: Bool {
    return false
  }

  public private(set) var overlayNode: ASDisplayNode?
  public let bodyNode: D

  private let animationTargetNode: ASDisplayNode
  private let highlightAnimation: HighlightAnimationDescriptor
  private let haptics: HapticsDescriptor?
  private var highlightHandler: HighlightAnimationDescriptor.Context.Handler?

  private var onTapClosure: () -> Void = {}
  private var onChangedSelectedClosure: (Bool) -> Void = { _ in }

  // MARK: - Initializers
  
  public init(
    animation: HighlightAnimationDescriptor,
    haptics: HapticsDescriptor? = nil,
    contentNode: D
  ) {
    
    self.haptics = haptics
    
    let body = contentNode
    self.bodyNode = body
    if body.isLayerBacked {
      /**
       If body uses layer-backing, it can't take a view to animate by UIView based animation.
       With wrapping another node, it enables body-node can be animatable.
       */
      self.animationTargetNode = AnyWrapperNode { body }
    } else {
      self.animationTargetNode = body
    }
    self.highlightAnimation = animation
    super.init()
    
    clipsToBounds = false
    
    addSubnode(animationTargetNode)
    
  }

  @available(*, deprecated, message: "Use contentNode parameter for bodyNode")
  public init(
    animation: HighlightAnimationDescriptor,
    haptics: HapticsDescriptor? = nil,
    _ bodyNode: () -> D
  ) {
    self.haptics = haptics
    
    let body = bodyNode()
    self.bodyNode = body
    if body.isLayerBacked {
      /**
       If body uses layer-backing, it can't take a view to animate by UIView based animation.
       With wrapping another node, it enables body-node can be animatable.
       */
      self.animationTargetNode = AnyWrapperNode { body }
    } else {
      self.animationTargetNode = body
    }
    self.highlightAnimation = animation
    super.init()
    
    clipsToBounds = false
    
    addSubnode(animationTargetNode)
  }

  open override func didLoad() {
    super.didLoad()
    let context = highlightAnimation.prepare()

    if let overlay = context.overlay {
      let node = ASDisplayNode.init(viewBlock: {
        overlay
      })
      self.overlayNode = node
      addSubnode(node)
      setNeedsLayout()
    }

    self.highlightHandler = context.handler
  }

  open override func layoutSpecThatFits(
    _ constrainedSize: ASSizeRange
  ) -> ASLayoutSpec {
    if let overlayNode = self.overlayNode {
      return ASOverlayLayoutSpec(child: animationTargetNode, overlay: overlayNode)
    } else {
      return ASWrapperLayoutSpec(layoutElement: animationTargetNode)
    }
  }

  open override var isHighlighted: Bool {
    didSet {
      highlightHandler?(isHighlighted, self.view, animationTargetNode.view)
    }
  }
  
  open override var isSelected: Bool {
    didSet {
      guard isSelected != oldValue else {
        return
      }
      onChangedSelectedClosure(isSelected)
    }
  }

  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    haptics?.send(event: .onTouchDownInside)
  }

  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    haptics?.send(event: .onTouchUpInside)
    onTapClosure()
  }

  @discardableResult
  public func onTap(_ handler: @escaping () -> Void) -> Self {
    onTapClosure = handler
    return self
  }
  
  @discardableResult
  public func onChangedIsSelected(_ handler: @escaping (Bool) -> Void) -> Self {
    onChangedSelectedClosure = handler
    return self
  }

}

/// To avoid runtime error with ObjC
open class AnyHighlightCellNode: HighlightCellNode<ASDisplayNode> {

}
