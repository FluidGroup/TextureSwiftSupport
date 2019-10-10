//
//  ViewController.swift
//  SpecBuilder
//
//  Created by Muukii on 06/14/2019.
//  Copyright (c) 2019 Muukii. All rights reserved.
//

import UIKit

import AsyncDisplayKit
import TextureSwiftSupport
import SwiftUI

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let node = MyNode()
    let layout = node.calculateSizeThatFits(CGSize(width: 100, height: 100))
    node.frame.origin = .init(x: 100, y: 100)
    node.frame.size = layout
    
    view.addSubview(node.view)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  
  }

}

func makeBoxNode(_ color: UIColor) -> ASDisplayNode {
  let node = ASDisplayNode()
  node.backgroundColor = color
  return node
}

func makeTextNode(_ string: String) -> ASTextNode {
  let node = ASTextNode()
  node.attributedText = NSAttributedString(string: "hello")
  return node
}

final class MyNode : ASDisplayNode {
  
  private let boxNode = makeBoxNode(.lightGray)
  private let textNode1 = makeTextNode("Hello")
  private let textNode2 = makeTextNode("Hello")
  private let textNode3 = makeTextNode("Hello")
  private let textNode4 = makeTextNode("Hello")
  private let textNode5 = makeTextNode("Hello")
  private let textNode6 = makeTextNode("Hello")
  private let textNode7 = makeTextNode("Hello")
  
  private let textNode8 = makeTextNode("Hello!")
  private let backgroundNode = ASDisplayNode()
  
  override init() {
    super.init()
    
    automaticallyManagesSubnodes = true
    
    backgroundNode.backgroundColor = .orange
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    LayoutSpec {
      VStackLayout {
        AspectRatioLayout(ratio: CGSize(width: 3, height: 4)) {
          boxNode
        }
        HStackLayout {
          InsetLayout(insets: .init(top: 4, left: 4, bottom: 4, right: 4)) {
            textNode1
          }
          textNode2
        }
        textNode3
        
        ASLayoutSpec()
        
        HStackLayout {
          textNode4
          textNode5
          textNode6
        }
        
        textNode8
          .padding([.vertical], 4)
          .background(backgroundNode)
        
      }
    }    
  }
  
}
