//
//  MethodChain.swift
//  TextureSwiftSupport
//
//  Created by muukii on 2019/10/09.
//  Copyright © 2019 muukii. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

public enum Edge: Int8, CaseIterable {
  
  case top = 0
  case left = 1
  case bottom = 2
  case right = 3
  
  public struct Set: OptionSet {
    
    public var rawValue: Int8
    public var isEmpty: Bool {
      rawValue == 0
    }
    
    public init(rawValue: Int8) {
      self.rawValue = rawValue
    }
    
    public static let top: Set = .init(rawValue: 1 << 1)
    public static let left: Set = .init(rawValue: 1 << 2)
    public static let bottom: Set = .init(rawValue: 1 << 3)
    public static let right: Set = .init(rawValue: 1 << 4)

    public static var horizontal: Set {
      [.left, .right]
    }
    
    public static var vertical: Set {
      [.top, .bottom]
    }
    
    public static var all: Set {
      [.top, .bottom, .right, left]
    }
    
  }
  
}

@inline(__always)
fileprivate func makeInsets(_ padding: CGFloat) -> UIEdgeInsets {
  .init(top: padding, left: padding, bottom: padding, right: padding)
}

@inline(__always)
fileprivate func makeInsets(_ edges: Edge.Set, _ padding: CGFloat) -> UIEdgeInsets {
  var insets = UIEdgeInsets.zero
  
  if edges.contains(.top) {
    insets.top = padding
  }
  
  if edges.contains(.left) {
    insets.left = padding
  }
  
  if edges.contains(.bottom) {
    insets.bottom = padding
  }
  
  if edges.contains(.right) {
    insets.right = padding
  }
  return insets
}

fileprivate func combineInsets(_ lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
  var base = lhs
  base.top += rhs.top
  base.right += rhs.right
  base.left += rhs.left
  base.bottom += rhs.bottom
  return base
}

// MARK: - Padding
extension _ASLayoutElementType {
  
  public func padding(_ padding: CGFloat) -> InsetLayout<Self> {
    InsetLayout(insets: makeInsets(padding)) {
      self
    }
  }
  
  public func padding(_ edgeInsets: UIEdgeInsets) -> InsetLayout<Self> {
    InsetLayout(insets: edgeInsets) {
      self
    }
  }
  
  public func padding(_ edges: Edge.Set, _ padding: CGFloat) -> InsetLayout<Self> {
            
    return InsetLayout(insets: makeInsets(edges, padding)) {
      self
    }
  }
  
}

extension InsetLayout {
  
  public func padding(_ padding: CGFloat) -> Self {
    var _self = self
    _self.insets = combineInsets(_self.insets, rhs: makeInsets(padding))
    return _self
  }
  
  public func padding(_ edgeInsets: UIEdgeInsets) -> Self {
    var _self = self
    _self.insets = combineInsets(_self.insets, rhs: edgeInsets)
    return _self
  }
  
  public func padding(_ edges: Edge.Set, _ padding: CGFloat) -> Self {
    var _self = self
    _self.insets = combineInsets(_self.insets, rhs: makeInsets(edges, padding))
    return _self
  }
  
}

// MARK: - Background

extension _ASLayoutElementType {
  
  public func background<Background: _ASLayoutElementType>(_ backgroundContent: Background) -> BackgroundLayout<Background, Self> {
    BackgroundLayout(content: { self }, background: { backgroundContent })
  }
    
  public func overlay<Overlay: _ASLayoutElementType>(_ overlayContent: Overlay) -> OverlayLayout<Overlay, Self> {
    OverlayLayout(content: { self }, overlay: { overlayContent })
  }
  
  /// Make aspectRatio
  ///
  /// - Parameters:
  ///   - aspectRatio: The ratio of width to height to use for the resulting view
  public func aspectRatio(_ aspectRatio: CGFloat) -> AspectRatioLayout<Self> {
    AspectRatioLayout(ratio: aspectRatio, content: { self })
  }
  
  /// Make aspectRatio
  ///
  /// - Parameters:
  ///   - aspectRatio: The ratio of CGSize to use for the resulting view
  public func aspectRatio(_ aspectRatio: CGSize) -> AspectRatioLayout<Self> {
    AspectRatioLayout(ratio: aspectRatio, content: { self })
  }
}

public struct FlexGlowModifier: ModifierType {
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    element.style.flexGrow = 1
    return element
  }
}

public struct FlexShrinkModifier: ModifierType {
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    element.style.flexShrink = 1
    return element
  }
}

public struct PreferredSizeModifier: ModifierType {
  
  public var preferredSize: CGSize
      
  public init(preferredSize: CGSize) {
    self.preferredSize = preferredSize
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    element.style.preferredSize = preferredSize
    return element
  }
}

public struct AlignSelfModifier: ModifierType {
  
  public var alignSelf: ASStackLayoutAlignSelf
  
  public init(alignSelf: ASStackLayoutAlignSelf) {
    self.alignSelf = alignSelf
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    element.style.alignSelf = alignSelf
    return element
  }
}

extension _ASLayoutElementType {
  
  public func modify(_ modify: @escaping (ASLayoutElement) -> Void) -> ModifiedContent<Self, Modifier> {
    modifier(
      .init { element in
        modify(element)
        return element
      }
    )
  }
  
  public func flexGrow(_ flexGlow: CGFloat) -> ModifiedContent<Self, FlexGlowModifier> {
    modifier(FlexGlowModifier())
  }
  
  public func flexShrink(_ flexGlow: CGFloat) -> ModifiedContent<Self, FlexShrinkModifier> {
    modifier(FlexShrinkModifier())
  }
  
  public func preferredSize(_ preferredSize: CGSize) -> ModifiedContent<Self, PreferredSizeModifier> {
    modifier(PreferredSizeModifier(preferredSize: preferredSize))
  }
  
  public func alignSelf(_ alignSelf: ASStackLayoutAlignSelf) -> ModifiedContent<Self, AlignSelfModifier> {
    modifier(AlignSelfModifier(alignSelf: alignSelf))
  }
    
}
