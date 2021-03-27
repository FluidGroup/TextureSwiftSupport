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

/**
 A display node that supports interactions tap and long-press.
 According to that, animations are also supported.
 */
open class InteractiveNode<D: ASDisplayNode>: NamedDisplayControlNodeBase {
  public struct Handlers {
    public var onTap: () -> Void = {}
    public var onLongPress: (CGPoint) -> Void = { _ in }
  }

  override open var supportsLayerBacking: Bool {
    return false
  }

  public var longPressGestureRecognizer: UILongPressGestureRecognizer?

  public var handlers = Handlers()

  public let overlayNode: ASDisplayNode?
  public let bodyNode: D

  private let animationTargetNode: ASDisplayNode
  private let onChangedIsHighlighted: HighlightAnimationDescriptor

  private let useLongPressGesture: Bool

  // MARK: - Initializers

  public init(
    animation: HighlightAnimationDescriptor,
    useLongPressGesture: Bool = false,
    _ bodyNode: () -> D
  ) {
    self.useLongPressGesture = useLongPressGesture

    overlayNode = animation.overlayNode
    let body = bodyNode()
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
    onChangedIsHighlighted = animation

    super.init()

    clipsToBounds = false

    addSubnode(animationTargetNode)

    overlayNode.map {
      addSubnode($0)
    }
  }

  override open func didLoad() {
    super.didLoad()

    addTarget(
      self,
      action: #selector(_touchUpInside),
      forControlEvents: .touchUpInside
    )

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

  override open var isHighlighted: Bool {
    didSet {
      onChangedIsHighlighted.animation(isHighlighted, self, animationTargetNode)
    }
  }

  @objc private func _touchUpInside(_ gesture: UITapGestureRecognizer) {
    handlers.onTap()
  }

  @objc private func _onLongPress(_ gesture: UILongPressGestureRecognizer) {
    guard case .began = gesture.state else { return }
    let point = gesture.location(in: gesture.view)
    handlers.onLongPress(point)
  }

  @discardableResult
  public func onTap(_ handler: @escaping () -> Void) -> Self {
    handlers.onTap = handler
    return self
  }

  @discardableResult
  public func onLongPress(_ handler: @escaping (CGPoint) -> Void) -> Self {
    handlers.onLongPress = handler
    return self
  }
}
