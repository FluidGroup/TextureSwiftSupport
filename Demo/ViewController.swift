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

final class MyNode : ASDisplayNode {
  
  private let textNode1 = ASTextNode()
  private let textNode2 = ASTextNode()
  private let textNode3 = ASTextNode()
  
  override init() {
    super.init()
    
    textNode1.attributedText = NSAttributedString(string: "hello")
    textNode2.attributedText = NSAttributedString(string: "hello")
    textNode3.attributedText = NSAttributedString(string: "hello")
    
    automaticallyManagesSubnodes = true
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      children: [
        textNode1,
        textNode2,
        textNode3,
      ]
    )
          
//    AS.LayoutSpec {
//      AS.VStack {
//        textNode1
//        textNode2
//        textNode3
//      }
//    }
    
  }
  
}
