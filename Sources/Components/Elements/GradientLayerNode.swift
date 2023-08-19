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
import Descriptors

fileprivate final class GradientLayerView: UIView {
  override class var layerClass: AnyClass {
    CAGradientLayer.self
  }
}

@available(*, deprecated, renamed: "GradientLayerNode")
public typealias GradientNode = GradientLayerNode

open class GradientLayerNode : ASDisplayNode {

  private var usingDescriptor: LinearGradientDescriptor?

  open override var supportsLayerBacking: Bool {
    return false
  }
  
  public var gradientLayer: CAGradientLayer {
    view.layer as! CAGradientLayer
  }
  
  public init(descriptor: LinearGradientDescriptor? = nil) {

    self.usingDescriptor = descriptor

    super.init()
    shouldAnimateSizeChanges = false
    setViewBlock {
      GradientLayerView()
    }
    
    backgroundColor = .clear
  }

  open override func didLoad() {
    super.didLoad()

    lock()
    usingDescriptor?.apply(to: (self.view.layer as! CAGradientLayer))
    unlock()

  }

  open func setDescriptor(descriptor: LinearGradientDescriptor) {

    lock()
    defer {
      unlock()
    }

    assert(Thread.isMainThread)

    usingDescriptor = descriptor

    if self.isNodeLoaded {
      ASPerformBlockOnMainThread {
        descriptor.apply(to: (self.view.layer as! CAGradientLayer))
      }
    } else {
      // will be applied on didLoad
    }

  }
}
