//
//  AdaptiveLayoutViewController.swift
//  Demo
//
//  Created by muukii on 2020/05/07.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

import AsyncDisplayKit
import TextureSwiftSupport

final class AdaptiveLayoutViewController: DisplayNodeViewController {
  
  private let node1 = makeAdaptiveNode()
  private let node2 = makeAdaptiveNode()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
    
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
         
    LayoutSpec {
      VStackLayout(justifyContent: .center) {
        node1
        node2
      }
      .padding(50)
    }
  }
  
}

extension AdaptiveLayoutViewController {
  
  static func makeAdaptiveNode() -> FunctionalDisplayNode {
    
    let boxes = [
      Mocks.ButtonNode(),
      Mocks.ButtonNode(),
      Mocks.ButtonNode(),
    ]
    
    return FunctionalDisplayNode { _, _ in
      LayoutSpec {
        VStackLayout {
          Case(.init { _ in true }) {
            VStackLayout {
              boxes
            }
          }
        }
      }
    }
    
  }
  
}
