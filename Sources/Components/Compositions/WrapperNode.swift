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

open class WrapperNode<Content: ASDisplayNode>: ASDisplayNode {

  public struct Layout {

    public var aspectRatio: CGSize?

    public init(aspectRatio: CGSize? = nil) {
      self.aspectRatio = aspectRatio
    }
  }
  
  open override var supportsLayerBacking: Bool {
    false
  }
  
  public let content: Content

  public private(set) var layout: Layout {
    didSet {
      setNeedsLayout()
    }
  }

  public init(
    layout: Layout = .init(),
    content: Content
  ) {
    self.layout = layout
    let content = content
    self.content = content
    super.init()
    addSubnode(content)
  }

  @available(*, deprecated, message: "Use init(layout:content:)")
  public init(
    child: () -> Content
  ) {
    self.layout = .init()
    let content = child()
    self.content = content
    super.init()
    addSubnode(content)
  }

  public func aspectRatio(_ ratio: CGSize) -> Self {
    lock()
    defer {
      unlock()
    }

    layout.aspectRatio = ratio

    return self
  }

  public final override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    var spec: ASLayoutSpec = ASWrapperLayoutSpec(layoutElement: content)

    if let aspectRatio = layout.aspectRatio {
      spec = ASRatioLayoutSpec(ratio: aspectRatio.height / aspectRatio.width, child: spec)
    }

    return spec

  }

}

open class AnyWrapperNode: WrapperNode<ASDisplayNode> {
  
}
