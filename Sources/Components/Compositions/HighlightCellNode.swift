import AsyncDisplayKit

open class HighlightCellNode<D: ASDisplayNode>: NamedDisplayCellNodeBase {

  public typealias BodyNode = D

  open override var supportsLayerBacking: Bool {
    return false
  }

  public let overlayNode: ASDisplayNode?
  public let bodyNode: D

  private let animationTargetNode: ASDisplayNode
  private let highlightAnimation: HighlightAnimationDescriptor
  private let haptics: HapticsDescriptor?

  private var onTapClosure: () -> Void = {}

  // MARK: - Initializers

  public init(
    animation: HighlightAnimationDescriptor,
    haptics: HapticsDescriptor? = nil,
    _ bodyNode: () -> D
  ) {

    self.haptics = haptics

    self.overlayNode = animation.overlayNode
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
    self.overlayNode.map {
      addSubnode($0)
    }
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
      highlightAnimation.animation(isHighlighted, self, animationTargetNode)
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

}

/// To avoid runtime error with ObjC
open class AnyHighlightCellNode: HighlightCellNode<ASDisplayNode> {

}
