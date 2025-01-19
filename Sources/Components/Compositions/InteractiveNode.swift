//
// Copyright (c) 2021 Hiroshi Kimura(Muukii) <muukii.app@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import AsyncDisplayKit
import Foundation
import Descriptors

/**
 A display node that supports interactions tap and long-press.
 According to that, animations are also supported.
 */
open class InteractiveNode<D: ASDisplayNode>: NamedDisplayNodeBase {

  public typealias BodyNode = D
  
  public struct Handlers {
    public var onTap: @MainActor () -> Void = {}
    public var onLongPress: @MainActor (CGPoint) -> Void = { _ in }
  }

  override open var supportsLayerBacking: Bool {
    return false
  }

  public var longPressGestureRecognizer: UILongPressGestureRecognizer?

  public var handlers = Handlers()

  public private(set) var overlayNode: ASDisplayNode?
  public let bodyNode: D

  private let animationTargetNode: ASDisplayNode
  private let highlightAnimation: HighlightAnimationDescriptor

  private let useLongPressGesture: Bool
  private let haptics: HapticsDescriptor?
  private var highlightHandler: HighlightAnimationDescriptor.Context.Handler?

  // MARK: - Initializers
  
  public init(
    animation: HighlightAnimationDescriptor,
    haptics: HapticsDescriptor? = nil,
    useLongPressGesture: Bool = false,
    contentNode: D
  ) {
    self.haptics = haptics
    self.useLongPressGesture = useLongPressGesture
    
    let body = contentNode
    self.bodyNode = body
    if body.isLayerBacked {
      /**
       If body uses layer-backing, it can't take a view to animate by UIView based animation.
       With wrapping another node, it enables body-node can be animatable.
       */
      animationTargetNode = AnyWrapperNode { body }
    } else {
      animationTargetNode = body
    }
    highlightAnimation = animation
    
    super.init()
    
    clipsToBounds = false
    
    addSubnode(animationTargetNode)
  }

  @available(*, deprecated, message: "Use another initializer that receives content without closure")
  public convenience init(
    animation: HighlightAnimationDescriptor,
    haptics: HapticsDescriptor? = nil,
    useLongPressGesture: Bool = false,
    _ bodyNode: () -> D
  ) {

    self.init(
      animation: animation,
      haptics: haptics,
      useLongPressGesture: useLongPressGesture,
      contentNode: bodyNode()
    )
    
  }

  @MainActor
  override open func didLoad() {
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

    if useLongPressGesture {
      let longPressGesture = UILongPressGestureRecognizer(
        target: self,
        action: #selector(_onLongPress(_:))
      )
      view.addGestureRecognizer(longPressGesture)
      longPressGestureRecognizer = longPressGesture
    }
  }

  override open func layoutSpecThatFits(
    _ constrainedSize: ASSizeRange
  ) -> ASLayoutSpec {
    if let overlayNode = self.overlayNode {
      return ASOverlayLayoutSpec(child: animationTargetNode, overlay: overlayNode)
    } else {
      return ASWrapperLayoutSpec(layoutElement: animationTargetNode)
    }
  }

  @MainActor
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    super.touchesBegan(touches, with: event)
    
    highlightHandler?(true, self.view, animationTargetNode.view)
    haptics?.send(event: .onTouchDownInside)
  }
  
  @MainActor
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    super.touchesEnded(touches, with: event)
    
    highlightHandler?(false, self.view, animationTargetNode.view)
    
    guard !shouldCancelTouches(touches) else {
      return
    }
    
    haptics?.send(event: .onTouchUpInside)
    handlers.onTap()
  }
  
  @MainActor
  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    super.touchesMoved(touches, with: event)
    
    if shouldCancelTouches(touches) {
      highlightHandler?(false, self.view, animationTargetNode.view)
    } else {
      highlightHandler?(true, self.view, animationTargetNode.view)
    }
  }
  
  @MainActor
  public override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    highlightHandler?(false, self.view, animationTargetNode.view)
  }

  @MainActor
  @objc private func _onLongPress(_ gesture: UILongPressGestureRecognizer) {
    guard case .began = gesture.state else { return }
    let point = gesture.location(in: gesture.view)

    haptics?.send(event: .onLongPress)
    handlers.onLongPress(point)
  }

  @discardableResult
  public func onTap(_ handler: @escaping @MainActor () -> Void) -> Self {
    handlers.onTap = handler
    return self
  }

  @discardableResult
  public func onLongPress(_ handler: @escaping @MainActor (CGPoint) -> Void) -> Self {
    handlers.onLongPress = handler
    return self
  }
  
  private func shouldCancelTouches(_ touches: Set<UITouch>) -> Bool {
    guard
      let touch = touches.first,
      bounds.insetBy(dx: -50, dy: -50).contains(touch.location(in: self.view)) else {
      return true
    }
    return false
  }
}
