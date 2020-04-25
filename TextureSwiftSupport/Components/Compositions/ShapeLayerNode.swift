//
//  ShapeLayerNode.swift
//  AppUIKit
//
//  Created by muukii on 2019/01/27.
//  Copyright © 2019 eure. All rights reserved.
//

import Foundation

import AsyncDisplayKit

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
      CAShapeLayer()
    }
  }
}

/// A node that displays shape with CAShapeLayer
public final class ShapeLayerNode : ASDisplayNode, ShapeDisplaying {
  
  private let backingNode = BackingShapeLayerNode()

  private let updateClosure: Update

  public override var supportsLayerBacking: Bool {
    return false
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
      return backingNode.layer.strokeColor.map { UIColor(cgColor: $0) }
    }
    set {
      ASPerformBlockOnMainThread {
        self.backingNode.layer.strokeColor = newValue?.cgColor
      }
    }
  }
  
  public var shapeFillColor: UIColor? {
    get {
      return backingNode.layer.fillColor.map { UIColor(cgColor: $0) }
    }
    set {
      ASPerformBlockOnMainThread {
        self.backingNode.layer.fillColor = newValue?.cgColor
      }
    }
  }
  
  public override func layout() {
    super.layout()
    backingNode.layer.path = updateClosure(backingNode.bounds).cgPath
  }
  
  public override var frame: CGRect {
    didSet {
      ASPerformBlockOnMainThread {
        self.backingNode.layer.path = self.updateClosure(self.backingNode.bounds).cgPath
      }
    }
  }

  public init(update: @escaping Update) {
    self.updateClosure = update
    super.init()
    backgroundColor = .clear
    backingNode.backgroundColor = .clear
    shapeFillColor = .clear
    backingNode.isLayerBacked = true
    automaticallyManagesSubnodes = true
  }

  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    ASWrapperLayoutSpec(
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
    
  }

}
