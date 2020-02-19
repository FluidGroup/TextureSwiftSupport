//
//  LayoutSpecBuildable.swift
//  TextureSwiftSupport
//
//  Created by Geektree0101 on 19/02/2020.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation
import AsyncDisplayKit

public enum LayoutSpecBuildableOptions {
  
  case safeArea
  case layoutMargins
}

public protocol LayoutSpecBuildable {
  
  var layoutSpec: ASLayoutSpec { get }
}

private var layoutSpecBuildableConstrainedSizeKey: String = "LayoutSpecBuildable.constrainedSize"

extension LayoutSpecBuildable where Self: ASDisplayNode {
  
  public var constraintedSize: ASSizeRange {
    get {
      return (objc_getAssociatedObject(
        self,
        &layoutSpecBuildableConstrainedSizeKey
        ) as? ASSizeRange) ?? ASSizeRangeUnconstrained
    }
    set {
      objc_setAssociatedObject(
        self,
        &layoutSpecBuildableConstrainedSizeKey,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  public func automaticallyManagesLayoutSpecBuilder(changeSet: LayoutSpecBuildableOptions...) {
    
    self.automaticallyRelayoutOnSafeAreaChanges = changeSet.contains(.safeArea)
    self.automaticallyRelayoutOnLayoutMarginsChanges = changeSet.contains(.layoutMargins)
    self.automaticallyManagesLayoutSpecBuilder()
  }
  
  
  public func automaticallyManagesLayoutSpecBuilder() {
    
    self.automaticallyManagesSubnodes = true
    self.layoutSpecBlock = { [weak self] (_, sizeRange) -> ASLayoutSpec in
      self?.constraintedSize = sizeRange
      return self?.layoutSpec ?? ASLayoutSpec()
    }
  }
}
