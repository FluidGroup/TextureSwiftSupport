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
      let layout = AS.HStack {
        ASTextNode()
      }
    }
    
    do {
      let layout = AS.HStack {
        ASTextNode()
        ASTextNode()
      }
    }
    
    do {
      let layout = AS.HStack {
        AS.Inset(insets: .zero) {
          AS.HStack {
            ASTextNode()
            ASTextNode()
          }
        }
      }
    }
    
    do {
      let layout = AS.HStack {
        if true {
          ASTextNode()
        } else {
          ASButtonNode()
        }
      }
    }
    
    do {
      let layout = AS.HStack {
        ASTextNode()
        ASTextNode()
        ASButtonNode()
        AS.VStack {
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
      //      let layout = ASHStack {
      //        if true {
      //          ASTextNode()
      //        }
      //      }
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
