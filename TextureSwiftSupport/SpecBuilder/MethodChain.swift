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
  
  private let flexGrow: CGFloat
  
  init(flexGrow: CGFloat) {
    self.flexGrow = flexGrow
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    element.style.flexGrow = flexGrow
    return element
  }
}

public struct FlexShrinkModifier: ModifierType {
  
  private let flexShrink: CGFloat
  
  init(flexShrink: CGFloat) {
    self.flexShrink = flexShrink
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    element.style.flexShrink = flexShrink
    return element
  }
}

public struct SpacingModifier: ModifierType {
  
  public let after: CGFloat?
  public let before: CGFloat?

  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    after.map {
      element.style.spacingAfter = $0
    }
    before.map {
      element.style.spacingBefore = $0
    }
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

public struct SizeModifier: ModifierType {
  
  public var width: ASDimension?
  public var height: ASDimension?
  
  public init(size: CGSize) {
    self.width = .init(unit: .points, value: size.width)
    self.height = .init(unit: .points, value: size.height)
  }
  
  public init(width: ASDimension?, height: ASDimension?) {
    self.width = width
    self.height = height
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    width.map {
      element.style.width = $0
    }
    height.map {
      element.style.height = $0
    }
    return element
  }
}

public struct MinSizeModifier: ModifierType {
  
  public var minWidth: ASDimension?
  public var minHeight: ASDimension?
  
  public init(minSize: CGSize) {
    self.minWidth = .init(unit: .points, value: minSize.width)
    self.minHeight = .init(unit: .points, value: minSize.height)
  }
  
  public init(minWidth: ASDimension?, minHeight: ASDimension?) {
    self.minWidth = minWidth
    self.minHeight = minHeight
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    minWidth.map {
      element.style.minWidth = $0
    }
    minHeight.map {
      element.style.minHeight = $0
    }
    return element
  }
}

public struct MaxSizeModifier: ModifierType {
  
  public var maxWidth: ASDimension?
  public var maxHeight: ASDimension?
  
  public init(maxSize: CGSize) {
    self.maxWidth = .init(unit: .points, value: maxSize.width)
    self.maxHeight = .init(unit: .points, value: maxSize.height)
  }
  
  public init(maxWidth: ASDimension?, maxHeight: ASDimension?) {
    self.maxWidth = maxWidth
    self.maxHeight = maxHeight
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    maxWidth.map {
      element.style.maxWidth = $0
    }
    maxHeight.map {
      element.style.maxHeight = $0
    }
    return element
  }
}

public struct FlexBasisModifieer: ModifierType {
  
  public let flexBasis: ASDimension
  
  public init(flexBasis: ASDimension) {
    self.flexBasis = flexBasis
  }
  
  public func modify(element: ASLayoutElement) -> ASLayoutElement {
    element.style.flexBasis = flexBasis
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
    modifier(FlexGlowModifier(flexGrow: flexGlow))
  }
  
  public func flexShrink(_ flexShrink: CGFloat) -> ModifiedContent<Self, FlexShrinkModifier> {
    modifier(FlexShrinkModifier(flexShrink: flexShrink))
  }
  
  public func flexBasis(fraction: CGFloat) -> ModifiedContent<Self, FlexBasisModifieer> {
    modifier(FlexBasisModifieer(flexBasis: .init(unit: .fraction, value: fraction)))
  }
  
  public func preferredSize(_ preferredSize: CGSize) -> ModifiedContent<Self, SizeModifier> {
    modifier(SizeModifier(size: preferredSize))
  }
  
  public func alignSelf(_ alignSelf: ASStackLayoutAlignSelf) -> ModifiedContent<Self, AlignSelfModifier> {
    modifier(AlignSelfModifier(alignSelf: alignSelf))
  }
  
  public func minWidth(_ width: CGFloat) -> ModifiedContent<Self, MinSizeModifier> {
    modifier(MinSizeModifier(minWidth: .init(unit: .points, value: width), minHeight: nil))
  }
  
  public func minHeight(_ height: CGFloat) -> ModifiedContent<Self, MinSizeModifier> {
    modifier(MinSizeModifier(minWidth: nil, minHeight: .init(unit: .points, value: height)))
  }
  
  public func width(_ width: CGFloat) -> ModifiedContent<Self, SizeModifier> {
    modifier(SizeModifier(width: .init(unit: .points, value: width), height: nil))
  }
  
  public func height(_ height: CGFloat) -> ModifiedContent<Self, SizeModifier> {
    modifier(SizeModifier(width: nil, height: .init(unit: .points, value: height)))
  }
    
  public func minSize(_ size: CGSize) -> ModifiedContent<Self, MinSizeModifier> {
    modifier(MinSizeModifier(minSize: size))
  }
  
  public func maxWidth(_ width: CGFloat) -> ModifiedContent<Self, MaxSizeModifier> {
    modifier(MaxSizeModifier(maxWidth: .init(unit: .points, value: width), maxHeight: nil))
  }
  
  public func maxHeight(_ height: CGFloat) -> ModifiedContent<Self, MaxSizeModifier> {
    modifier(MaxSizeModifier(maxWidth: nil, maxHeight: .init(unit: .points, value: height)))
  }
  
  public func maxSize(_ size: CGSize) -> ModifiedContent<Self, MaxSizeModifier> {
    modifier(MaxSizeModifier(maxSize: size))
  }
  
  public func spacingAfter(_ spacing: CGFloat) -> ModifiedContent<Self, SpacingModifier> {
    modifier(SpacingModifier(after: spacing, before: nil))
  }
  
  public func spacingBefore(_ spacing: CGFloat) -> ModifiedContent<Self, SpacingModifier> {
    modifier(SpacingModifier(after: nil, before: spacing))
  }
}

extension ModifiedContent where Modifier == MinSizeModifier {
  
  public func minWidth(_ width: CGFloat) -> Self {
    var _self = self
    _self.modifier.minWidth = .init(unit: .points, value: width)
    return _self
  }
  
  public func minHeight(_ height: CGFloat) -> Self {
    var _self = self
    _self.modifier.minWidth = .init(unit: .points, value: height)
    return _self
  }
  
  public func minSize(_ size: CGSize) -> Self {
    var _self = self
    _self.modifier = MinSizeModifier(minSize: size)
    return _self
  }
  
}

extension ModifiedContent where Modifier == MaxSizeModifier {
  
  public func maxWidth(_ width: CGFloat) -> Self {
    var _self = self
    _self.modifier.maxWidth = .init(unit: .points, value: width)
    return _self
  }
  
  public func maxHeight(_ height: CGFloat) -> Self {
    var _self = self
    _self.modifier.maxWidth = .init(unit: .points, value: height)
    return _self
  }
  
  public func maxSize(_ size: CGSize) -> Self {
    var _self = self
    _self.modifier = MaxSizeModifier(maxSize: size)
    return _self
  }
  
}
