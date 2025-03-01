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

@available(*, deprecated, renamed: "AnyDisplayNode")
public typealias FunctionalDisplayNode = AnyDisplayNode

/**
 A type-erasing display node that supports to composite other nodes and lay them out.

 It helps to avoid creating a new symbol when you need to composite nodes from elements.

 - Attention: Creating a new symbol cause increase app binary size.
 In iOS apps, almost of symbols are UI components.
 Especially, it's getting much more symbols with Component oriented programming.
 In the basic implementation approach, creates symbols for each component. However, there are several components that no need to be symbol.
 
 In this case, we can use an anonymous UI component class as a base.
 
 https://github.com/muukii/Swift-binary-size

 If you need to inject specific props into AnyDisplayNode, you can use `AnyPropsDisplayNode`.
 However, this does not affect increasing binary size effectively because it emits symbols of each generic parameter.


 ```swift
 func myNode() -> AnyDisplayNode {

   let label = ASTextNode()

   return AnyDisplayNode { _, _ in
     LayoutSpec {
       VStackLayout {
         label
       }
     }
   }
 }
 ```
 */
open class AnyDisplayNode: SafeAreaDisplayNode {
  
  private var retainItems: [Any]
  
  private let hook: Hook = .init()
  
  public init(
    _ name: String = "",
    _ file: StaticString = #file,
    _ function: StaticString = #function,
    _ line: UInt = #line,
    retainsUntilDeinitItems: [Any] = [],
    layoutSpecBlock: @escaping (AnyDisplayNode, ASSizeRange) -> ASLayoutSpec
  ) {
        
    self.retainItems = retainsUntilDeinitItems
    super.init()
    self.layoutSpecBlock = { node, constrainedSize in
      layoutSpecBlock(node as! AnyDisplayNode, constrainedSize)
    }
    self.automaticallyRelayoutOnSafeAreaChanges = true
    self.automaticallyRelayoutOnLayoutMarginsChanges = true
    self.automaticallyManagesSubnodes = true
    
    #if DEBUG
    let file = URL(string: file.description)?.deletingPathExtension().lastPathComponent ?? "unknown"
    self.accessibilityIdentifier = [
      name,
      file,
      function.description,
      line.description
      ]
      .joined(separator: ".")
    #endif
  }
    
  @MainActor
  open override func didLoad() {
    super.didLoad()
    hook.onDidload(self)
  }
  
  @MainActor
  open override func layout() {
    super.layout()
    hook.onLayout(self)
  }

  @available(*, unavailable)
  open override func onDidLoad(_ body: @escaping @MainActor (ASDisplayNode) -> Void) {
    super.onDidLoad(body)
  }

  @discardableResult
  public final func onDidLoad(_ onDidLoad: @escaping @MainActor (AnyDisplayNode) -> Void) -> Self {
    hook.onDidload = onDidLoad
    return self
  }

  @discardableResult
  public final func onLayout(_ onLayout: @escaping @MainActor (AnyDisplayNode) -> Void) -> Self {
    hook.onLayout = onLayout
    return self
  }

  @discardableResult
  public final func associate(_ object: Any) -> Self {
    retainItems.append(object)
    return self
  }

  @discardableResult
  public final func setBackgroundColor(_ color: UIColor) -> Self {
    backgroundColor = color
    return self
  }

  @discardableResult
  public final func setIsLayerBacked(_ isEnabled: Bool) -> Self {
    isLayerBacked = isEnabled
    return self
  }
     
}

public typealias PropsFunctionalDisplayNode = AnyPropsDisplayNode

/// It's not so effective in reducing binary-size.
public final class AnyPropsDisplayNode<Props>: AnyDisplayNode {
  
  private var _onUpdatedProps: (ASDisplayNode, Props) -> Void = { _, _ in }
  
  public func onUpdatedProps(_ onUpdatedProps: @escaping (ASDisplayNode, Props) -> Void) -> Self {
    self._onUpdatedProps = onUpdatedProps
    return self
  }
  
  public func update(props: Props) {
    _onUpdatedProps(self, props)
  }
  
}

extension AnyDisplayNode {
  
  public final class Hook {
    
    var onDidload: @MainActor (AnyDisplayNode) -> Void = { _ in }
    var onLayout: @MainActor (AnyDisplayNode) -> Void = { _ in }
    
    init() {}
    
  }
  
}
