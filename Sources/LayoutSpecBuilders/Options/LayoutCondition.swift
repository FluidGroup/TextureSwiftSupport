//
// Copyright (c) 2020 Hiroshi Kimura(Muukii) <muuki.app@gmail.com>
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

public struct LayoutContext {
  
  public let constraintSize: ASSizeRange
  public let parentSize: CGSize
  public let trait: ASTraitCollection
  
}

/// A condition to lay children out
public struct LayoutCondition {
  
  private let closure: (LayoutContext) -> Bool
  
  /// - Parameter closure: Make sure a operation can perform thread-safety due to closure runs in any thread.
  public init(_ closure: @escaping (LayoutContext) -> Bool) {
    self.closure = closure
  }
  
  /// Make Combined
  public init(and conditions: [LayoutCondition]) {
    self.init { trait in
      for condition in conditions {
        guard condition.matches(context: trait) else {
          return false
        }
      }
      return true
    }
  }
  
  /// Make Combined comparer
  /// - Parameter comparers:
  public init(or conditions: [LayoutCondition]) {
    self.init { trait in
      for condition in conditions {
        if condition.matches(context: trait) {
          return true
        }
      }
      return false
    }
  }
  
  public func matches(context: LayoutContext) -> Bool {
    closure(context)
  }
}

prefix operator >=
prefix operator <=

public prefix func >=(d: LayoutCondition.Dimension) -> LayoutCondition.Constraint {
  .greaterThanOrEqual(d)
}

public prefix func <=(d: LayoutCondition.Dimension) -> LayoutCondition.Constraint {
  .lessThanOrEqual(d)
}

public prefix func >=(points: CGFloat) -> LayoutCondition.Constraint {
  .greaterThanOrEqual(points: points)
}

public prefix func <=(points: CGFloat) -> LayoutCondition.Constraint {
  .lessThanOrEqual(points: points)
}

public func &&(lhs: LayoutCondition, rhs: LayoutCondition) -> LayoutCondition {
  return .init(and: [lhs, rhs])
}

public func ||(lhs: LayoutCondition, rhs: LayoutCondition) -> LayoutCondition {
  return .init(or: [lhs, rhs])
}

extension LayoutCondition {
  
  public struct Dimension {
    public let points: CGFloat
    
    public init(_ rawValue: CGFloat) {
      self.points = rawValue
    }
  }
  
  public enum Constraint {
    case greaterThanOrEqual(Dimension)
    case lessThanOrEqual(Dimension)
    
    public static func greaterThanOrEqual(points: CGFloat) -> Constraint {
      .greaterThanOrEqual(Dimension(points))
    }
    public static func lessThanOrEqual(points: CGFloat) -> Constraint {
      .lessThanOrEqual(Dimension(points))
    }
    
  }
  
  public enum Sizing {
    case width
    case height
  }
  
  @inline(__always)
  private static func _matches(length: CGFloat, constraint: Constraint) -> Bool {
    switch constraint {
    case .greaterThanOrEqual(let l):
      return length >= l.points
    case .lessThanOrEqual(let l):
      return length <= l.points
    }
  }
  
  @inline(__always)
  private static func _matches(size: CGSize, sizing: Sizing, constraint: Constraint) -> Bool {
    switch sizing {
    case .width:
      return _matches(length: size.width, constraint: constraint)
    case .height:
      return _matches(length: size.height, constraint: constraint)
    }
  }
  
  public static func containerSize(_ sizing: Sizing, _ constraint: Constraint) -> Self {
    return .init { context in
      _matches(size: context.trait.containerSize, sizing: sizing, constraint: constraint)
    }
  }
  
  public static func minConstraintSize(_ sizing: Sizing, _ constraint: Constraint) -> Self {
    return .init { context in
      _matches(size: context.constraintSize.min, sizing: sizing, constraint: constraint)
    }
  }
  
  public static func maxConstraintSize(_ sizing: Sizing, _ constraint: Constraint) -> Self {
    return .init { context in
      _matches(size: context.constraintSize.max, sizing: sizing, constraint: constraint)
    }
  }
      
  public static func parentSize(_ sizing: Sizing, _ constraint: Constraint) -> Self {
    return .init { context in
      _matches(size: context.parentSize, sizing: sizing, constraint: constraint)
    }
  }
}
