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
    
}
