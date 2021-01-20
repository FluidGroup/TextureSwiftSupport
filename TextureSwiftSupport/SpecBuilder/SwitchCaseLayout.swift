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

fileprivate let emptyLayout = ASLayoutSpec()

final class _CaseLayoutSpec: ASLayoutSpec {
  
  let condition: LayoutCondition
  
  private let makeContent: () -> [ASLayoutElement]
  private lazy var content: ASWrapperLayoutSpec = {
    ASWrapperLayoutSpec(layoutElements: makeContent())
  }()
  
  init(
    condition: LayoutCondition,
    makeContent: @escaping () -> [ASLayoutElement]
  ) {
    self.condition = condition
    self.makeContent = makeContent
    super.init()
  }
  
  override func calculateLayoutThatFits(
    _ constrainedSize: ASSizeRange,
    restrictedTo size: ASLayoutElementSize,
    relativeToParentSize parentSize: CGSize
  ) -> ASLayout {
    
    let context = LayoutContext(
      constraintSize: constrainedSize,
      parentSize: parentSize,
      trait: asyncTraitCollection()
    )
    
    guard condition.matches(context: context) else {
      return emptyLayout.calculateLayoutThatFits(constrainedSize, restrictedTo: size, relativeToParentSize: parentSize)
    }
    
    return content.calculateLayoutThatFits(constrainedSize)
  }
   
}

final class _SwitchLayoutSpec: ASLayoutSpec {
  
  private let cases: [_CaseLayoutSpec]
  
  init(cases: [_CaseLayoutSpec]) {
    self.cases = cases
    super.init()
  }
  
  override func calculateLayoutThatFits(
    _ constrainedSize: ASSizeRange,
    restrictedTo size: ASLayoutElementSize,
    relativeToParentSize parentSize: CGSize
  ) -> ASLayout {
        
    let context = LayoutContext(
      constraintSize: constrainedSize,
      parentSize: parentSize,
      trait: asyncTraitCollection()
    )
    
    for _case in cases {
      if _case.condition.matches(context: context) {
        return _case.calculateLayoutThatFits(constrainedSize, restrictedTo: size, relativeToParentSize: parentSize)
      }
    }
    
    return emptyLayout.calculateLayoutThatFits(constrainedSize, restrictedTo: size, relativeToParentSize: parentSize)
        
  }
  
}

public struct Case: _ASLayoutElementType {
    
  private let makeContent: () -> [ASLayoutElement]
  public let condition: LayoutCondition
  
  public init<Content: _ASLayoutElementType>(
    _ condition: LayoutCondition,
    _ content: @escaping () -> Content
  ) {
    
    self.condition = condition
    
    self.makeContent = {
      content().make()
    }
    
  }
  
  public func make() -> [ASLayoutElement] {
    [_CaseLayoutSpec(condition: condition, makeContent: makeContent)]
  }
  
  func makeConditionalLayoutSpec() -> _CaseLayoutSpec {
    _CaseLayoutSpec(condition: condition, makeContent: makeContent)
  }
}

@_functionBuilder public struct ArrayBuilder<Element> {
  
  public static func buildBlock() -> [Element] {
    []
  }
  
  public static func buildBlock(_ content: Element) -> [Element] {
    [content]
  }
  
  public static func buildBlock(_ contents: Element...) -> [Element] {
    contents
  }
  
  public static func buildBlock(_ contents: [Element]) -> [Element] {
    contents
  }
  
  public static func buildBlock(_ contents: Element?...) -> [Element] {
    contents.compactMap { $0 }
  }
  
  public static func buildBlock(_ contents: [Element?]) -> [Element] {
    contents.compactMap { $0 }
  }
  
}

public struct Switch: _ASLayoutElementType {
  
  private let cases: [Case]
  
  public init(
    @ArrayBuilder<Case> _ content: @escaping () -> [Case]
  ) {
    self.cases = content()
  }
  
  @_disfavoredOverload
  public init(
    @ArrayBuilder<Case> _ content: @escaping () -> Case
  ) {
    self.cases = [content()]
  }
  
  public func make() -> [ASLayoutElement] {
    [_SwitchLayoutSpec(cases: cases.map { $0.makeConditionalLayoutSpec() })]
  }
  
}
