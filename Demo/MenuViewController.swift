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
import GlossButtonNode
import TypedTextAttributes

fileprivate let descriptor = GlossButtonDescriptor(bodyStyle: .init(layout: .horizontal()), surfaceStyle: .bodyOnly)

final class MenuViewController: PlainDisplayNodeViewController {
  
  private let openSampleButtonNode = GlossButtonNode()
  private let openAdaptiveButtonNode = GlossButtonNode()
  private let openCompositionCatalogButtonNode = GlossButtonNode()
  private let topLabelNode = ASTextNode()
  
  override init() {
    
    super.init()
    view.backgroundColor = .white
    
    topLabelNode.attributedText = .init(string: "Attatched on safe-area")
        
    openSampleButtonNode.setDescriptor(descriptor.title("OpenSample".styled { $0.font(.boldSystemFont(ofSize: 18)).foregroundColor(.systemBlue) }), for: .normal)
    openSampleButtonNode.onTap = { [weak self] in
      let controller = InstagramPostCellViewController()
      self?.navigationController?.pushViewController(controller, animated: true)
    }
    
    openAdaptiveButtonNode.setDescriptor(descriptor.title("OpenAdaptive".styled { $0.font(.boldSystemFont(ofSize: 18)).foregroundColor(.systemBlue) }), for: .normal)
    openAdaptiveButtonNode.onTap = { [weak self] in
      let controller = AdaptiveLayoutViewController()
      self?.navigationController?.pushViewController(controller, animated: true)
    }
    
    openCompositionCatalogButtonNode.setDescriptor(descriptor.title("Open Composition".styled { $0.font(.boldSystemFont(ofSize: 18)).foregroundColor(.systemBlue) }), for: .normal)
    openCompositionCatalogButtonNode.onTap = { [weak self] in
      let controller = CompositionCatalogViewController()
      self?.navigationController?.pushViewController(controller, animated: true)
    }

  }
    
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      
      ZStackLayout {
        
        topLabelNode
          .padding(UIEdgeInsets(top: 0, left: 0, bottom: .infinity, right: .infinity))
        
        CenterLayout {
          VStackLayout {
            openSampleButtonNode
            openAdaptiveButtonNode
            openCompositionCatalogButtonNode
          }
        }
        
      }
      .padding(capturedSafeAreaInsets)
      
    }
  }
}
