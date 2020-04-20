//
//  MenuViewController.swift
//  Demo
//
//  Created by muukii on 2020/04/21.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

import AsyncDisplayKit
import TextureSwiftSupport

final class MenuViewController: PlainDisplayNodeViewController {
  
  private let openSampleButtonNode = ASButtonNode()
  private let topLabelNode = ASTextNode()
  
  override init() {
    
    super.init()
    view.backgroundColor = .white
    
    topLabelNode.attributedText = .init(string: "Attatched on safe-area")
    openSampleButtonNode.setTitle("OpenSample", with: nil, with: .systemBlue, for: .normal)
    openSampleButtonNode.addTarget(self, action: #selector(tapOpenSampleButton), forControlEvents: .touchUpInside)
  }
  
  @objc
  private func tapOpenSampleButton() {
    let controller = InstagramPostCellViewController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      
      ZStackLayout {
        
        topLabelNode
          .padding(UIEdgeInsets(top: 0, left: 0, bottom: .infinity, right: .infinity))
        
        CenterLayout {
          openSampleButtonNode
        }
        
      }
      .padding(capturedSafeAreaInsets)
      
    }
  }
}
