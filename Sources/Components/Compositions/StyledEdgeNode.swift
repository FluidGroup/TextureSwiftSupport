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
import Descriptors

public final class AnyStyledEdgeNode: StyledEdgeNode<ASDisplayNode> {

}

///
/// - Ref: https://texturegroup.org/docs/corner-rounding.html
public enum StyledEdgeCornerRoundingStrategy {
  /// High-performance
  case clip(assimilationColor: UIColor)
  /// Low-performance
  /// It appears their background.
  case mask
}

public struct StyledEdgeBorderDescriptor {
  public var width: CGFloat
  public var color: UIColor

  public init(width: CGFloat, color: UIColor) {
    self.width = width
    self.color = color
  }
}

/**
 It supports
 - Rounds the corner (clipping or masking)
 - Displays a border
 */
public class StyledEdgeNode<ContentNode: ASDisplayNode>: NamedDisplayNodeBase {

  public override var supportsLayerBacking: Bool {
    contentNode.supportsLayerBacking
  }

  public override var isLayerBacked: Bool {
    didSet {
      // apply decsandant
      contentNode.isLayerBacked = isLayerBacked
    }
  }

  public var contentNode: ContentNode

  public var border: StyledEdgeBorderDescriptor? {
    didSet {
      updateBorder()
    }
  }

  public var cornerRoundingStrategy: StyledEdgeCornerRoundingStrategy {
    didSet {
      updateStrategy()
    }
  }

  private let _cornerRadius: CGFloat

  /// A node that displays shape for border
  /// The border won't be displayed from only this node.
  /// It would be displayed with clipping or masking.
  private let borderNode: ShapeLayerNode

  /// A node that displays a shape to make the corner are rounded.
  private let clipNode: ShapeDrawingNode

  /// A node that displays a shape to use as a mask to clipping the corner.
  private let maskNode: ShapeDrawingNode

  @available(*, unavailable, message: "Don't touch me")
  public override var cornerRadius: CGFloat {
    didSet {

    }
  }

  @available(*, deprecated, message: "Use new initializer instead")
  public convenience init(
    embedNode: ContentNode,
    cornerRoundingColor: UIColor,
    cornerRadius: CGFloat
  ) {

    self.init(
      cornerRadius: cornerRadius,
      cornerRoundingStrategy: .clip(assimilationColor: cornerRoundingColor),
      contentNode: { embedNode }
    )

  }
  
  public init(
    cornerRadius: CGFloat,
    cornerRoundingStrategy: StyledEdgeCornerRoundingStrategy,
    border: StyledEdgeBorderDescriptor? = nil,
    contentNode: ContentNode
  ) {
    
    self.cornerRoundingStrategy = cornerRoundingStrategy
    self.contentNode = contentNode
    self._cornerRadius = cornerRadius
    self.clipNode = .roundedCornerInversed(radius: cornerRadius)
    self.maskNode = .roundedCorner(radius: cornerRadius)
    self.border = border
    self.borderNode = .roundedCorner(radius: cornerRadius)

    super.init()

    clipNode.accessibilityIdentifier = "clipNode"
    maskNode.accessibilityIdentifier = "maskNode"
    borderNode.accessibilityIdentifier = "borderLayer"

    /// To prevent rendering misaligned pixel by stacking layer.
    /// Technically, In case of the body's content black and border white, the edges of the corner would display black pixels.
    borderNode.usesInnerBorder = false

    borderNode.isUserInteractionEnabled = false
    clipNode.isUserInteractionEnabled = false

    automaticallyManagesSubnodes = true

    [
      borderNode,
      maskNode,
      clipNode,
    ].forEach {
      $0.isLayerBacked = true
    }

    clipsToBounds = true

    // to disable animation
    updateBorder()
    updateStrategy()
  }
  
  @available(*, deprecated, message: "Use init that not using closure to get contentNode.")
  public convenience init(
    cornerRadius: CGFloat,
    cornerRoundingStrategy: StyledEdgeCornerRoundingStrategy,
    border: StyledEdgeBorderDescriptor? = nil,
    contentNode: @autoclosure () -> ContentNode
  ) {

    self.init(
      cornerRadius: cornerRadius,
      cornerRoundingStrategy: cornerRoundingStrategy,
      border: border,
      contentNode: contentNode
    )

  }

  @available(*, deprecated, message: "Use init that not using closure to get contentNode.")
  public convenience init(
    cornerRadius: CGFloat,
    cornerRoundingStrategy: StyledEdgeCornerRoundingStrategy,
    border: StyledEdgeBorderDescriptor? = nil,
    contentNode: () -> ContentNode
  ) {

    self.init(
      cornerRadius: cornerRadius,
      cornerRoundingStrategy: cornerRoundingStrategy,
      border: border,
      contentNode: contentNode()
    )

  }

  public override func didLoad() {
    super.didLoad()

    // to disable animation
    updateBorder()
    updateStrategy()

    self.borderNode.shapeLayer.fillRule = .evenOdd
  }

  private func updateBorder() {

    ASPerformBlockOnMainThread {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      defer {
        CATransaction.commit()
      }

      if let border = self.border {
        self.borderNode.shapeFillColor = .clear
        self.borderNode.shapeStrokeColor = border.color
        self.borderNode.shapeLineWidth = border.width * 2 // to get inner border
        self.borderNode.isHidden = false
      } else {
        self.borderNode.isHidden = true
      }

      self.setNeedsLayout()
    }
  }

  private func updateStrategy() {

    ASPerformBlockOnMainThread {

      CATransaction.begin()
      CATransaction.setDisableActions(true)
      defer {
        CATransaction.commit()
      }

      switch self.cornerRoundingStrategy {
      case .clip(let assimilationColor):

        self.clipNode.shapeFillColor = assimilationColor

        self.isOpaque = true

      case .mask:

        self.isOpaque = false

      }

      self.setNeedsLayout()
    }

  }

  public override func layoutDidFinish() {

    super.layoutDidFinish()

    CATransaction.begin()
    CATransaction.setDisableActions(true)
    defer {
      CATransaction.commit()
    }

    switch cornerRoundingStrategy {
    case .clip:
      self.layer.mask = nil
    case .mask:
      self.maskNode.shapeFillColor = .black
      self.layer.mask = maskNode.layer
      break
    }

  }

  public override func layoutSpecThatFits(
    _ constrainedSize: ASSizeRange
  ) -> ASLayoutSpec {

    switch cornerRoundingStrategy {
    case .clip:
      return ASOverlayLayoutSpec(
        child: contentNode,
        overlay: ASWrapperLayoutSpec(
          layoutElements: [
            borderNode,
            clipNode,
          ]
        )
      )
    case .mask:
      return ASOverlayLayoutSpec(
        child: contentNode,
        overlay: ASWrapperLayoutSpec(
          layoutElements: [
            borderNode,
            maskNode,
          ]
        )
      )
    }

  }

}

extension ShapeDisplaying {

  fileprivate static func roundedCornerInversed(radius: CGFloat) -> Self {
    return self.init { bounds in
      let framePath = UIBezierPath(rect: bounds)
      let clipPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
      framePath.usesEvenOddFillRule = true
      framePath.append(clipPath)
      return framePath
    }
  }

}
