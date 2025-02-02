
import Foundation

import AsyncDisplayKit
import Descriptors

fileprivate final class BackingShapeLayerNode : ASDisplayNode {
  
  public override var supportsLayerBacking: Bool {
    return true
  }
  
  public override var layer: CAShapeLayer {
    return super.layer as! CAShapeLayer
  }
        
  public override init() {
    super.init()
    setLayerBlock {
      let shape = CAShapeLayer()
      shape.fillColor = UIColor.clear.cgColor
      shape.strokeColor = UIColor.clear.cgColor
      return shape
    }
  }

  fileprivate var shapeStrokeColor: UIColor? {
    didSet {
      ASPerformBlockOnMainThread {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        defer {
          CATransaction.commit()
        }
        self.layer.strokeColor = self.shapeStrokeColor?
          .resolvedColor(with: .init(userInterfaceStyle: self.asyncTraitCollection().userInterfaceStyle))
          .cgColor
      }
    }
  }

  public var shapeFillColor: UIColor? {
    didSet {
      ASPerformBlockOnMainThread {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        defer {
          CATransaction.commit()
        }
        self.layer.fillColor = self.shapeFillColor?
          .resolvedColor(with: .init(userInterfaceStyle: self.asyncTraitCollection().userInterfaceStyle))
          .cgColor
      }
    }
  }

  override func asyncTraitCollectionDidChange(
    withPreviousTraitCollection previousTraitCollection: ASPrimitiveTraitCollection
  ) {
    super.asyncTraitCollectionDidChange(withPreviousTraitCollection: previousTraitCollection)
    lazy var userInterfaceStyle = asyncTraitCollection().userInterfaceStyle
    guard
      isNodeLoaded,
      previousTraitCollection.userInterfaceStyle != userInterfaceStyle
    else {
      return
    }
    ASPerformBlockOnMainThread {
      self.layer.strokeColor = self.shapeStrokeColor?
        .resolvedColor(with: .init(userInterfaceStyle: userInterfaceStyle))
        .cgColor
      self.layer.fillColor = self.shapeFillColor?
        .resolvedColor(with: .init(userInterfaceStyle: userInterfaceStyle))
        .cgColor
    }
  }
}

/// A node that displays shape with CAShapeLayer
public final class ShapeLayerNode : ASDisplayNode, ShapeDisplaying {
  
  private let backingNode = BackingShapeLayerNode()

  private let updateClosure: Update

  public var usesInnerBorder: Bool = true {
    didSet {
      setNeedsLayout()
    }
  }

  public override var supportsLayerBacking: Bool {
    return true
  }
  
  public var shapeLayer: CAShapeLayer {
    backingNode.layer
  }
  
  // To be thread-safe, using stored property
  public var shapeLineWidth: CGFloat = 0 {
    didSet {
      backingNode.layer.lineWidth = shapeLineWidth
      setNeedsLayout()
    }
  }

  public var shapeStrokeColor: UIColor? {
    get {
      return backingNode.shapeStrokeColor
    }
    set {
      backingNode.shapeStrokeColor = newValue
    }
  }
  
  public var shapeFillColor: UIColor? {
    get {
      return backingNode.shapeFillColor
    }
    set {
      backingNode.shapeFillColor = newValue
    }
  }
  
  public override func layout() {
    super.layout()
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    defer {
      CATransaction.commit()
    }
    backingNode.layer.path = updateClosure(backingNode.bounds).cgPath
  }
  
  public override var frame: CGRect {
    didSet {
      ASPerformBlockOnMainThread {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        defer {
          CATransaction.commit()
        }
        self.backingNode.layer.path = self.updateClosure(self.backingNode.bounds).cgPath
      }
    }
  }

  public init(
    update: @escaping Update
  ) {
    self.updateClosure = update
    super.init()
    backgroundColor = .clear
    backingNode.backgroundColor = .clear
    backingNode.isLayerBacked = true
    automaticallyManagesSubnodes = true
  }

  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    if usesInnerBorder {
      return ASWrapperLayoutSpec(
        layoutElement: ASInsetLayoutSpec(
          insets: .init(
            top: shapeLineWidth / 2,
            left: shapeLineWidth / 2,
            bottom: shapeLineWidth / 2,
            right: shapeLineWidth / 2
          ),
          child: backingNode
        )
      )
    } else {
      return ASWrapperLayoutSpec(layoutElement: backingNode)
    }
    
  }

}
