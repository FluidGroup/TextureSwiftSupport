//
//  ShapeDisplaying.swift

import Foundation
import AsyncDisplayKit

import UIKit

public protocol ShapeDisplaying: AnyObject {
  
  typealias Update = (CGRect) -> UIBezierPath
  
  init(update: @escaping Update)
  
  var shapeFillColor: UIColor? { get set }
  
  var shapeLineWidth: CGFloat { get set }
  
  var shapeStrokeColor: UIColor? { get set }
}

extension ShapeDisplaying {

  @discardableResult
  public func setShapeFillColor(_ color: UIColor) -> Self {
    self.shapeFillColor = color
    return self
  }

  @discardableResult
  public func setShapeLineWidth(_ width: CGFloat) -> Self {
    self.shapeLineWidth = width
    return self
  }

  @discardableResult
  public func setStrokeColor(_ color: UIColor) -> Self {
    self.shapeStrokeColor = color
    return self
  }

}

public enum CupsuleShapeDirection {
  case vertical
  case horizontal
}

extension ShapeDisplaying {
  
  /// Returns an instance that displays capsule shape
  ///
  /// - Parameters:
  ///   - direction:
  ///   - usesSmoothCurve: SmoothCurve means Apple's using corner rouding. For example, Home App Icon's curve.
  /// - Returns: An instance
  public static func capsule(direction: CupsuleShapeDirection, usesSmoothCurve: Bool) -> Self {
    return self.init { bounds in
      guard usesSmoothCurve else {
        return UIBezierPath.init(roundedRect: bounds, cornerRadius: .infinity)
      }
      switch direction {
      case .horizontal:
        return UIBezierPath.init(roundedRect: bounds, cornerRadius: bounds.height / 2)
      case .vertical:
        return UIBezierPath.init(roundedRect: bounds, cornerRadius: bounds.width / 2)
      }
    }
  }
  
  /// Returns an instance that displays rounded corner shape.
  /// Rounded corner uses smooth-curve
  ///
  /// - Parameter radius:
  /// - Returns:
  public static func roundedCorner(radius: CGFloat) -> Self {
    return self.init { bounds in
      UIBezierPath.init(roundedRect: bounds, cornerRadius: radius)
    }
  }
  
}
