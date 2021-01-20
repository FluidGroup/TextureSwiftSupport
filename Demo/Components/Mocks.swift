//
//  RoundedColorBox.swift
//  Demo
//
//  Created by muukii on 2020/04/21.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

import AsyncDisplayKit
import TextureSwiftSupport

extension UIColor {
  // MARK: Public
  
  public convenience init(int hexInt: Int, alpha: CGFloat = 1) {
    self.init(
      red: CGFloat((hexInt & 0x00FF_0000) >> 16) / 255,
      green: CGFloat((hexInt & 0x0000_FF00) >> 8) / 255,
      blue: CGFloat((hexInt & 0x0000_00FF) >> 0) / 255,
      alpha: alpha
    )
  }
}

enum Mocks {
  
  static var fillColor: UIColor {
    .init(int: 0x157D9D, alpha: 0.2)
  }
  
  final class CircularImageNode: WrapperNode<ShapeLayerNode> {
    
    init() {
      
      let node = ShapeLayerNode.capsule(direction: .horizontal, usesSmoothCurve: false)
      node.shapeFillColor = fillColor
      
      super.init {
        node
      }
    }
    
  }
  
  final class ImageNode: WrapperNode<ASDisplayNode> {
    
    init() {
      
      let node = ASDisplayNode()
      node.backgroundColor = fillColor
      
      super.init {
        node
      }
    }
    
  }
  
  final class SingleLineTextNode: WrapperNode<AnyDisplayNode> {
    
    init() {
      
      let shape = ShapeLayerNode.capsule(direction: .horizontal, usesSmoothCurve: true)
      shape.shapeFillColor = fillColor
      
      super.init {
        AnyDisplayNode { _, _ in
          LayoutSpec {
            shape
              .height(16)
              .width(120)
              .padding(2)
          }
        }
      }
    }
  }
  
  final class ThumbNode: WrapperNode<AnyDisplayNode> {
    
    init() {
      
      let shape = ShapeLayerNode.capsule(direction: .horizontal, usesSmoothCurve: true)
      shape.shapeFillColor = fillColor
      
      super.init {
        AnyDisplayNode { _, _ in
          LayoutSpec {
            shape
              .height(6)
              .width(20)
              .padding(2)
          }
        }
      }
    }
  }
  
  final class ButtonNode: WrapperNode<AnyDisplayNode> {
    
    var onTap: () -> Void = {}
    
    init() {
      
      let shape = ShapeLayerNode.roundedCorner(radius: 8)
      shape.shapeFillColor = fillColor
      
      super.init {
        AnyDisplayNode { _, _ in
          LayoutSpec {
            shape
              .width(28)
              .height(28)
              .padding(2)
          }
        }
      }
    }
  }
  
  
  final class MultipleLineTextNode: WrapperNode<AnyDisplayNode> {
    
    init(lines: Int) {
      
      let shapes: [ASDisplayNode] = (0..<lines).map { _ in
        let node = ShapeLayerNode.capsule(direction: .horizontal, usesSmoothCurve: true)
        node.shapeFillColor = fillColor
        return node
      }
      
      super.init {
        AnyDisplayNode { _, _ in
          LayoutSpec {
            VStackLayout(spacing: 2) {
              shapes
                .width(120)
                .height(16)
            }
          }
        }
      }
    }
  }
  
}
