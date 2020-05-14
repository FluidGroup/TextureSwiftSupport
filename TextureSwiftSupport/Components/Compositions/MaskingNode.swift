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

import Foundation

import AsyncDisplayKit

/// A composition node that masks a node with another node.
///
/// It considers the intrinsic content size from Mask parameter node.
open class MaskingNode<MaskedContent: ASDisplayNode, Mask: ASDisplayNode>: NamedDisplayNodeBase {

  public enum Sizing {
    case maskedContent
    case maskContent
  }
  
  open override var supportsLayerBacking: Bool {
    false
  }
  
  public let maskedNode: MaskedContent
  public let maskNode: Mask
  public let sizing: Sizing

  private let debug: Bool
  
  public init(
    debug: Bool = false,
    sizing: Sizing = .maskContent,
    maskedContent: () -> MaskedContent,
    mask: () -> Mask
  ) {
    self.debug = debug
    self.maskedNode = maskedContent()
    self.maskNode = mask()
    self.sizing = sizing
    super.init()
    addSubnode(self.maskedNode)
    addSubnode(self.maskNode)
  }
  
  open override func layoutDidFinish() {
    super.layoutDidFinish()
    #if DEBUG
    if !debug {
      self.layer.mask = maskNode.layer
    }
    #else
    self.layer.mask = maskNode.layer
    #endif
  }
  
  public final override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    switch sizing {
    case .maskContent:
      return ASBackgroundLayoutSpec(child: maskNode, background: maskedNode)
    case .maskedContent:
      return ASOverlayLayoutSpec(child: maskedNode, overlay: maskNode)
    }
  }
}
