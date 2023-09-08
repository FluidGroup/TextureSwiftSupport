//
//  SwiftUISample.swift
//  TextureSwiftSupportTests
//
//  Created by muukii on 2020/07/25.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI

enum _SwiftUICompileCheck {

  func sample() {

    let view = VStack {
      if false {
        Text("")
      }
    }

    #if swift(>=5.3)
    do {

      let number = 1

      let view: VStack<_ConditionalContent<_ConditionalContent<Text, Text>, Text>> = VStack {
        switch number {
        case 1:
          Text("")
        case 2:
          Text("")
        default:
          Text("")
        }
      }

      _ = view

    }

    do {

      let value: String? = nil

      let view = VStack {
        if let v = value {
          Text("\(v)")
        } else {
          Text("")
        }
      }

    }
    #endif
  }
}

#endif
