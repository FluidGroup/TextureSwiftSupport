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

  }
}

#endif
