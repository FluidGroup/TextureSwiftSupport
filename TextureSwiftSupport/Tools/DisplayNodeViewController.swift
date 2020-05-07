//
// Copyright (c) 2020 Hiroshi Kimura(Muukii) <muuki.app@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import AsyncDisplayKit

/**
 Texture based ViewController
 This uses ASDisplayNode on the root view.

 - Author: TetureSwiftSupport
 */
open class DisplayNodeViewController: ASViewController<SafeAreaDisplayNode> {
  
  public var capturedSafeAreaInsets: UIEdgeInsets {
    node.capturedSafeAreaInsets
  }
  
  #if ASVIEWCONTROLLER_OVERRIDE_INIT
  public override init() {
    let rootNode = SafeAreaDisplayNode()
    rootNode.automaticallyManagesSubnodes = true
    
    super.init(node: rootNode)
    
    rootNode.layoutSpecBlock = { [weak self] node, constrainedSize in
      guard let self = self else {
        return ASWrapperLayoutSpec(layoutElements: [])
      }
      return self.layoutSpecThatFits(constrainedSize)
    }
    
  }
  #else
  public init() {
    let rootNode = SafeAreaDisplayNode()
    rootNode.automaticallyManagesSubnodes = true
    
    super.init(node: rootNode)
    
    rootNode.layoutSpecBlock = { [weak self] node, constrainedSize in
      guard let self = self else {
        return ASWrapperLayoutSpec(layoutElements: [])
      }
      return self.layoutSpecThatFits(constrainedSize)
    }
    
  }
  #endif
  
  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  /// Return a layout spec that describes the layout of the receiver and its children.
  /// - Parameter constrainedSize: The minimum and maximum sizes the receiver should fit in.
  open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElements: [])
  }
}

open class PlainDisplayNodeViewController: UIViewController {
  
  public var capturedSafeAreaInsets: UIEdgeInsets {
    node.capturedSafeAreaInsets
  }
  
  private let node: SafeAreaDisplayNode = .init()
  
  public init() {
    
    node.automaticallyManagesSubnodes = true
    
    super.init(nibName: nil, bundle: nil)
    
    node.layoutSpecBlock = { [weak self] node, constrainedSize in
      guard let self = self else {
        return ASWrapperLayoutSpec(layoutElements: [])
      }
      return self.layoutSpecThatFits(constrainedSize)
    }
    
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(node.view)
    node.view.frame = view.bounds
    node.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Return a layout spec that describes the layout of the receiver and its children.
  /// - Parameter constrainedSize: The minimum and maximum sizes the receiver should fit in.
  open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElements: [])
  }

  
}
