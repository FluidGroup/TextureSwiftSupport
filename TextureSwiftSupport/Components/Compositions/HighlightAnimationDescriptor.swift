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

public struct HighlightAnimationDescriptor {
  public typealias Block = (
    _ isHighlighted: Bool, _ containerNode: ASDisplayNode,
    _ bodyNode: ASDisplayNode
  ) -> Void

  public let animation: Block
  public let overlayNode: ASDisplayNode?

  public init(
    overlayNode: () -> ASDisplayNode? = { nil },
    animation: @escaping Block
  ) {
    self.overlayNode = overlayNode()
    self.animation = animation
  }
}

extension HighlightAnimationDescriptor {
  public static let noAnimation: Self = .init { _, _, _ in }

  ///
  public static let bodyShrink: HighlightAnimationDescriptor = customBodyShrink(
    shrinkingScale: 0.97
  )

  public static func customBodyShrink(
    shrinkingScale: CGFloat
  ) -> HighlightAnimationDescriptor {
    return .init { isHighlighted, containerNode, body in
      if isHighlighted {
        UIView.animate(
          withDuration: 0.4,
          delay: 0,
          usingSpringWithDamping: 1,
          initialSpringVelocity: 0,
          options: [.beginFromCurrentState, .allowUserInteraction],
          animations: {
            body.transform = CATransform3DMakeScale(shrinkingScale, shrinkingScale, 1)            
          },
          completion: nil
        )
      } else {
        UIView.animate(
          withDuration: 0.3,
          delay: 0.1,
          usingSpringWithDamping: 1,
          initialSpringVelocity: 0,
          options: [.beginFromCurrentState, .allowUserInteraction],
          animations: {
            body.transform = CATransform3DIdentity
          },
          completion: nil
        )
      }
    }
  }

  ///
  public static let translucent: HighlightAnimationDescriptor = .init {
    isHighlighted,
      containerNode,
      body in
    if isHighlighted {
      UIView.animate(
        withDuration: 0.12,
        delay: 0,
        options: [.beginFromCurrentState, .curveEaseIn, .allowUserInteraction],
        animations: {
          containerNode.alpha = 0.8
        },
        completion: nil
      )
    } else {
      UIView.animate(
        withDuration: 0.08,
        delay: 0.1,
        options: [.beginFromCurrentState, .allowUserInteraction],
        animations: {
          containerNode.alpha = 1
        },
        completion: nil
      )
    }
  }

  ///
  ///
  /// - Parameters:
  ///   - cornerRadius:
  ///   - insets:
  ///   - overlayColor:
  /// - Returns:
  public static func shrink(
    cornerRadius: CGFloat,
    insets: UIEdgeInsets,
    overlayColor: UIColor = .init(white: 0, alpha: 0.05)
  ) -> HighlightAnimationDescriptor {
    let containerNode = ASDisplayNode()
    let overlayNode = ShapeLayerNode.roundedCorner(radius: cornerRadius)

    containerNode.addSubnode(overlayNode)

    containerNode.layoutSpecBlock = { node, size in

      var insets = insets
      insets.top *= -1
      insets.right *= -1
      insets.bottom *= -1
      insets.left *= -1

      return ASInsetLayoutSpec(insets: insets, child: overlayNode)
    }

    containerNode.alpha = 0

    return .init(overlayNode: { containerNode }) { isHighlighted, _, body in

      overlayNode.shapeFillColor = overlayColor

      if isHighlighted {
        UIView.animate(
          withDuration: 0.26,
          delay: 0,
          options: [
            .beginFromCurrentState, .allowAnimatedContent,
            .allowUserInteraction, .curveEaseOut,
          ],
          animations: {
            containerNode.layer.opacity = 0.98
            containerNode.transform = CATransform3DMakeScale(0.98, 0.98, 1)
            body.view.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
          },
          completion: nil
        )

      } else {
        UIView.animate(
          withDuration: 0.20,
          delay: 0,
          options: [
            .beginFromCurrentState, .allowAnimatedContent,
            .allowUserInteraction, .curveEaseOut,
          ],
          animations: {
            containerNode.layer.opacity = 0
            containerNode.transform = CATransform3DIdentity
            body.view.transform = .identity
          },
          completion: nil
        )
      }
    }
  }

  ///
  public static func colorOverlay(
    overlayColor: UIColor = .init(white: 0, alpha: 0.05)
  ) -> HighlightAnimationDescriptor {
    let overlayNode = ASDisplayNode()
    overlayNode.backgroundColor = overlayColor
    overlayNode.alpha = 0

    return .init(overlayNode: { overlayNode }) { isHighlighted, _, _ in

      if isHighlighted {
        UIView.animate(
          withDuration: 0.12,
          delay: 0,
          options: [
            .beginFromCurrentState, .curveEaseIn, .allowUserInteraction,
          ],
          animations: {
            overlayNode.alpha = 1
          },
          completion: nil
        )

      } else {
        UIView.animate(
          withDuration: 0.08,
          delay: 0.1,
          options: [.beginFromCurrentState, .allowUserInteraction],
          animations: {
            overlayNode.alpha = 0
          },
          completion: nil
        )
      }
    }
  }
}
