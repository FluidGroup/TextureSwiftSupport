
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
}

/// A node that displays shape with CAShapeLayer
public final class ShapeLayerNode : ASDisplayNode, @preconcurrency  ShapeDisplaying, @unchecked Sendable {

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

  @MainActor
  public var shapeLayer: CAShapeLayer {
    backingNode.layer
  }
  
  // To be thread-safe, using stored property
  /// Should be set on mainThread, TODO: Discuss how to enforce the rule
  public var shapeLineWidth: CGFloat = 0 {
    didSet {
      MainActor.assumeIsolated {
        backingNode.layer.lineWidth = shapeLineWidth
        setNeedsLayout()
      }
    }
  }

  @MainActor
  public var shapeStrokeColor: UIColor? {
    get {
      return backingNode.layer.strokeColor.map { UIColor(cgColor: $0) }
    }
    set {
      // Keep it for now since we might have non confirming implementation
      ASPerformBlockOnMainThread {
        MainActor.assumeIsolated {

          CATransaction.begin()
          CATransaction.setDisableActions(true)
          defer {
            CATransaction.commit()
          }
          self.backingNode.layer.strokeColor = newValue?.cgColor
        }
      }
    }
  }

  @MainActor
  public var shapeFillColor: UIColor? {
    get {
      return backingNode.layer.fillColor.map { UIColor(cgColor: $0) }
    }
    set {
      // Keep it for now since we might have non confirming implementation
      ASPerformBlockOnMainThread {
        MainActor.assumeIsolated {

          CATransaction.begin()
          CATransaction.setDisableActions(true)
          defer {
            CATransaction.commit()
          }
          self.backingNode.layer.fillColor = newValue?.cgColor
        }
      }
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
        MainActor.assumeIsolated {
          CATransaction.begin()
          CATransaction.setDisableActions(true)
          defer {
            CATransaction.commit()
          }
          self.backingNode.layer.path = self.updateClosure(self.backingNode.bounds).cgPath
        }
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
