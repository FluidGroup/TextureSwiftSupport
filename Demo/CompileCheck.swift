//
//  CompileCheck.swift
//  SpecBuilder_Example
//
//  Created by muukii on 2019/06/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

import AsyncDisplayKit
import TextureSwiftSupport
//import SwiftUI

enum _CompileCheck {
  
  func foo() {
    
    do {
      let layout = HStackLayout {
        ASTextNode()
      }
    }
    
    do {
      let layout = HStackLayout {
        ASTextNode()
        ASTextNode()
      }
    }
    
    do {
      let layout = HStackLayout {
        InsetLayout(insets: .zero) {
          HStackLayout {
            ASTextNode()
            ASTextNode()
          }
        }
      }
    }
    
    do {
      
      let nodes = [
        ASTextNode(),
        ASTextNode(),
      ]
      
      let layout = HStackLayout {
        InsetLayout(insets: .zero) {
          HStackLayout {
            nodes
          }
        }
      }
    }
    
    do {
      
      let nodes: [AnyLayout] = [
        .init { ASTextNode() },
        .init { ASTextNode() },
      ]
      
      let layout = HStackLayout {
        InsetLayout(insets: .zero) {
          HStackLayout {
            nodes
          }
        }
      }
    }
          
    do {
      let layout = HStackLayout {
        if true {
          ASTextNode()
        } else {
          ASButtonNode()
        }
      }
    }
    
    do {
      let layout = HStackLayout {
        ASTextNode()
        ASTextNode()
        ASButtonNode()
        VStackLayout {
          ASTextNode()
        }
        if true {
          ASTextNode()
        } else {
          ASButtonNode()
        }
      }
    }
    
    do {
      
      let nodes = [ASDisplayNode(), ASDisplayNode()]
      
      _ = VStackLayout {
        nodes
      }
          
    }
    
    do {
      
      let nullNode: ASDisplayNode? = nil
      
      let layout = ZStackLayout {
        OptionalLayout { nullNode }
      }
      
    }
        
//    if #available(iOS 13.0, *) {
//      let ha = VStack {
//        Text("")
//        if true {
//          Text("")
//        }
//      }
//
//      let list = VStack {
//        ForEach([0]) { a in
//          Text("a")
//        }
//      }
//    } else {
//      
//    }
  }
  
  final class MyNode: ASDisplayNode {
    
    private let nameNode = ASTextNode()
    private let ageNode = ASTextNode()
    private let gradientBackgroundNode = GradientNode()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      LayoutSpec {
        HStackLayout {
          nameNode
          ageNode
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(gradientBackgroundNode)
      }
    }
  }
  
  final class MyNode2: ASDisplayNode {
    
    private let nameNode = ASTextNode()
    private let ageNode = ASTextNode()
    private let gradientBackgroundNode = GradientNode()
    
    private var isNameNodeHidden: Bool = false {
      didSet {
        setNeedsLayout()
      }
    }
    
    override init() {
      super.init()
      automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      LayoutSpec {
        HStackLayout {
          if !isNameNodeHidden {
            nameNode
          }
          ageNode
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(gradientBackgroundNode)
      }
    }
  }
  
  final class MyNodePlain: ASDisplayNode {
    
    private let nameNode = ASTextNode()
    private let ageNode = ASTextNode()
    private let gradientBackgroundNode = GradientNode()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
                       
      return ASBackgroundLayoutSpec(
        child:  ASInsetLayoutSpec(
          insets: .init(top: 16, left: 20, bottom: 16, right: 20),
          child: ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .start,
            alignItems: .stretch,
            children: [
              nameNode,
              ageNode
            ]
          )
        ),
        background: gradientBackgroundNode
      )
    }
    
  }
    
}
