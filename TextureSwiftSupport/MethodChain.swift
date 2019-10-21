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


// MARK: - Padding
extension _ASLayoutElementType {
  
  public func padding(_ padding: CGFloat) -> InsetLayout<Self> {
    InsetLayout(insets: .init(top: padding, left: padding, bottom: padding, right: padding)) {
      self
    }
  }
  
  public func padding(_ edgeInsets: UIEdgeInsets) -> InsetLayout<Self> {
    InsetLayout(insets: edgeInsets) {
      self
    }
  }
  
  public func padding(_ edges: Edge.Set, _ padding: CGFloat) -> InsetLayout<Self> {
    
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
    
    return InsetLayout(insets: insets) {
      self
    }
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
    
}
