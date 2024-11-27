
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
public final class ShapeLayerNode : ASDisplayNode, MainActorShapeDisplaying, @unchecked Sendable {

  private let backingNode = BackingShapeLayerNode()

  private let updateClosure: Update

  public var usesInnerBorder: Bool = true {
    didSet {
      setNeedsLayout()
    }
  }

  public init(update: @escaping Update) {
    self.updateClosure = update
    super.init()
    backgroundColor = .clear
    backingNode.backgroundColor = .clear
    backingNode.isLayerBacked = true
    automaticallyManagesSubnodes = true
  }

  /// Warning: shape\* values will actually be set at didLoad
  public convenience init (
  update: @escaping Update,
  shapeFillColor: UIColor = .clear,
  shapeStrokeColor: UIColor = .clear,
  shapeLineWidth: CGFloat = 0.0
  ) {
    self.init(update: update)
    backgroundColor = .clear
    backingNode.backgroundColor = .clear
    backingNode.isLayerBacked = true
    automaticallyManagesSubnodes = true
    self.onDidLoad({
      let shapeLayerNode = ($0 as! ShapeLayerNode)
      shapeLayerNode.shapeFillColor = shapeFillColor
      shapeLayerNode.shapeStrokeColor = shapeStrokeColor
      shapeLayerNode.shapeLineWidth = shapeLineWidth
    })
  }

  public override var supportsLayerBacking: Bool {
    return true
  }

  @MainActor
  /// Beware, direct access to lineWidth is not supported here when using usesInnerBorder, otherwise acess should be safe
  public var unsafeShapeLayer: CAShapeLayer {
    backingNode.layer
  }

  /// cache value for bg thread access
  private var _shapeLineWidth: CGFloat = .zero

  @MainActor
  public var shapeLineWidth: CGFloat = 0 {
    didSet {
      _shapeLineWidth = shapeLineWidth
      backingNode.layer.lineWidth = shapeLineWidth
      setNeedsLayout()
    }
  }

  @MainActor
  public var shapeStrokeColor: UIColor? {
    get {
      return backingNode.layer.strokeColor.map { UIColor(cgColor: $0) }
    }
    set {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      defer {
        CATransaction.commit()
      }
      self.backingNode.layer.strokeColor = newValue?.cgColor
    }
  }

  @MainActor
  public var shapeFillColor: UIColor? {
    get {
      return backingNode.layer.fillColor.map { UIColor(cgColor: $0) }
    }
    set {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      defer {
        CATransaction.commit()
      }
      self.backingNode.layer.fillColor = newValue?.cgColor
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

  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    if usesInnerBorder {
      return ASWrapperLayoutSpec(
        layoutElement: ASInsetLayoutSpec(
          insets: .init(
            top: _shapeLineWidth / 2,
            left: _shapeLineWidth / 2,
            bottom: _shapeLineWidth / 2,
            right: _shapeLineWidth / 2
          ),
          child: backingNode
        )
      )
    } else {
      return ASWrapperLayoutSpec(layoutElement: backingNode)
    }
    
  }

}
