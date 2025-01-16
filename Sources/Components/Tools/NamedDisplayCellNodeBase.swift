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

/// An object from Abstract base class
///
/// This object sets name of object for accessibilityIdentifier
/// The accessibilityIdentifier will be displayed on Reveal's view-tree.
/// It helps to find source code from Reveal.
///
/// - Author: TetureSwiftSupport
open class NamedDisplayCellNodeBase: ASCellNode {
  
  private var __actionHandlers: [@MainActor (NamedDisplayCellNodeBase, DisplayNodeAction) -> Void] = []
  
  @MainActor
  open override func didLoad() {
    super.didLoad()
    #if DEBUG
    Task.detached { [weak self] in
      guard let self = self else { return }
      let typeName = _typeName(type(of: self))

      Task { @MainActor in
        guard self.accessibilityIdentifier == nil else { return }
        self.accessibilityIdentifier = typeName
      }
    }
    #endif
    
    propagate(action: .didLoad)
    
  }
  
  /**
   - Warning: Non-atomic
   */
  @discardableResult
  public func addNodeActionHandler(_ handler: @escaping @MainActor (Self, DisplayNodeAction) -> Void) -> Self {
    __actionHandlers.append { node, action in
      guard let node = node as? Self else {
        assertionFailure()
        return
      }
      handler(node, action)
    }
    
    return self
  }
  
  @MainActor
  private func propagate(action: DisplayNodeAction) {
    for handler in __actionHandlers {
      handler(self, action)
    }
  }

  open var overrideUserinterfaceStyle: UIUserInterfaceStyle = .unspecified

  open override func setPrimitiveTraitCollection(_ traitCollection: ASPrimitiveTraitCollection) {

    // 🤷🏻‍♂️
    // texture does not support for UIView.overrideUserinterfaceStyle
    var _traitCollection = traitCollection
    if case .unspecified = overrideUserinterfaceStyle {

    } else {
      _traitCollection.userInterfaceStyle = overrideUserinterfaceStyle
    }
    super.setPrimitiveTraitCollection(_traitCollection)
  }
  
}
