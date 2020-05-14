//
//  CompositionCatalogViewController.swift
//  Demo
//
//  Created by muukii on 2020/05/11.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

import TextureSwiftSupport

final class CompositionCatalogViewController: DisplayNodeViewController {
  
  private let scrollNode = ASScrollNode()
  
  override init() {
    super.init()
    
    self.scrollNode.automaticallyManagesContentSize = true
    self.scrollNode.scrollableDirections = .down
    self.scrollNode.automaticallyManagesSubnodes = true
    
    let nodes: [ASDisplayNode] = [
      Self.makeMasking()
    ]

    self.scrollNode.layoutSpecBlock = { _, _ in

      LayoutSpec {
        VStackLayout(isConcurrent: true) {
          nodes
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      scrollNode
    }
  }
  
}

extension CompositionCatalogViewController {
  
  private static func makeFrameNode(_ body: ASDisplayNode) -> ASDisplayNode {
     
    return AnyDisplayNode { _ , _ in
      LayoutSpec {
        body
          .padding(20)
      }
    }
    
  }
  
  static func makeMasking() -> ASDisplayNode {
    
    let background = GradientNode()
      
    background.gradientLayer.colors = [
      #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor,
      #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor,
    ]
    background.gradientLayer.locations = [0, 1]
    background.gradientLayer.startPoint = .zero
    background.gradientLayer.endPoint = .init(x: 1, y: 1)
    
    func makeContent() -> ASDisplayNode {
      let text = ASTextNode()
      text.attributedText = "MaskingNode".styled {
        $0.foregroundColor(.black)
          .font(.boldSystemFont(ofSize: 18))
      }
      
      let shape = ShapeLayerNode.capsule(direction: .horizontal, usesSmoothCurve: true)
      shape.shapeStrokeColor = .black
      shape.shapeLineWidth = 3
      
      return AnyDisplayNode { _, _ in
        LayoutSpec {
          text
            .padding(10)
            .background(shape)
        }
      }
    }
    
   let mask = makeContent()
    
    let node = MaskingNode(
      maskedContent: {
        background
    },
      mask: {
        mask
    }
    )
    
    return makeFrameNode(node)
  }
  
}
