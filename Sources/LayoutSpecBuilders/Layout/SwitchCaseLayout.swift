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

/**
 To control the layout or nodes with hiding or display by some conditions.
 It will be helpful to support:
 - multiple screen sizes
 - screen direction
 - universal application
 - layout fitting on between iPhone SE and iPhone 11 Pro max...


 In Swith, `Case` only can declare.
 A node in first matched case will display.
 ```swift
 LayoutSpec {
   Switch {
     Case(.containerSize(.width, >=300)) {
       MyNode()
     }
     Case(.containerSize(.width, <=300)) {
       MyNode()
     }
   }
 }
 ```

 **it can declare `Case` isolated, like using if-else control flow.**
 ```
 LayoutSpec {
   Case(.containerSize(.height, >=300)) {
     MyNode()
   }
   Case(.maxConstraintSize(.height, >=300)) {
     MyNode()
   }
   Case(.parentSize(.height, >=300)) {
     MyNode()
   }
   VStackLayout {
     MyNode()
   }
 }
 ```

 **Creating custom condition**
 ```
 LayoutSpec {
   Case(.init { context in
     let _: ASSizeRange = context.constraintSize
     let _: CGSize = context.parentSize
     let _: ASTraitCollection = context.trait
     return false
   }) {
     MyNode()
   }
 }
 ```

 **Use combined condition*
 ```
 LayoutSpec {
   Case(.parentSize(.height, >=300) && .parentSize(.width, <=100)) {
     MyNode()
   }

   Case(.parentSize(.height, >=300) || .parentSize(.width, <=100)) {
     MyNode()
   }
 }
 ```

 **Nesting**
 ```
 LayoutSpec {
   Case(.parentSize(.height, >=300)) {
     Switch {
       Case(.parentSize(.height, >=300)) {
         MyNode()
       }
       Case(.parentSize(.height, >=300)) {
         Case(.parentSize(.height, >=300)) {
           Switch {
             Case(.parentSize(.height, >=300)) {
               MyNode()
             }
              Case(.parentSize(.height, >=300)) {
               MyNode()
             }
           }
         }
       }
     }
   }
 }
 ```
 */
public struct Switch: _ASLayoutElementType {
  
  private let cases: [Case]
  
  public init(
    @_ArrayBuilder<Case> _ content: @escaping () -> [Case]
  ) {
    self.cases = content()
  }
  
  @_disfavoredOverload
  public init(
    @_ArrayBuilder<Case> _ content: @escaping () -> Case
  ) {
    self.cases = [content()]
  }
  
  public func tss_make() -> [ASLayoutElement] {
    [_SwitchLayoutSpec(cases: cases.map { $0.makeConditionalLayoutSpec() })]
  }
  
}

/// Case descriptor for Switch Control Flow.
/// - SeeAlso: `Switch`
public struct Case: _ASLayoutElementType {

  private let makeContent: () -> [ASLayoutElement]
  public let condition: LayoutCondition

  public init<Content: _ASLayoutElementType>(
    _ condition: LayoutCondition,
    _ content: @escaping () -> Content
  ) {

    self.condition = condition

    self.makeContent = {
      content().tss_make()
    }

  }

  public func tss_make() -> [ASLayoutElement] {
    [_CaseLayoutSpec(condition: condition, makeContent: makeContent)]
  }

  func makeConditionalLayoutSpec() -> _CaseLayoutSpec {
    _CaseLayoutSpec(condition: condition, makeContent: makeContent)
  }
}

public struct ConditionInspector: _ASLayoutElementType {

  private let displayName: String

  private let onReceiveContext: (String, LayoutContext) -> Void

  public init(
    _ name: String? = nil,
    _ file: StaticString = #file,
    _ line: UInt = #line,
    onReceiveContext: @escaping (String, LayoutContext) -> Void = { displayName, context in
      print("[ConditionInspector] \(displayName), layoutCondition: \(context.debugDescription)")
    }
  ) {

    if let name = name {
      self.displayName = name
    } else {
      self.displayName = "\(file):\(line)"
    }

    self.onReceiveContext = onReceiveContext

  }

  public func tss_make() -> [ASLayoutElement] {
    [_CaseLayoutSpec(condition: .init { [displayName] (context: LayoutContext) in
      onReceiveContext(displayName, context)
      return true
    }, makeContent: {
      [ASLayoutSpec()]
    })]
  }
}

// MARK: - Internal

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
      restrictedSize: size,
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
      restrictedSize: size,
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

/// Experimental
public struct _ConditionReader<Content: _ASLayoutElementType>: _ASLayoutElementType {

  private let content: (LayoutContext) -> Content

  public init(@ASLayoutSpecBuilder content: @escaping (LayoutContext) -> Content) {
    self.content = content
  }

  public func tss_make() -> [ASLayoutElement] {
    [_ConditionalLayoutSpec(content: content)]
  }

}

/// Experimental
final class _ConditionalLayoutSpec<Content: _ASLayoutElementType>: ASLayoutSpec {

  private let content: (LayoutContext) -> Content

  init(@ASLayoutSpecBuilder content: @escaping (LayoutContext) -> Content) {
    self.content = content
    super.init()
  }

  override func calculateLayoutThatFits(
    _ constrainedSize: ASSizeRange,
    restrictedTo size: ASLayoutElementSize,
    relativeToParentSize parentSize: CGSize
  ) -> ASLayout {

    let context = LayoutContext(
      constraintSize: constrainedSize,
      restrictedSize: size,
      parentSize: parentSize,
      trait: asyncTraitCollection()
    )

    let layoutSpec = LayoutSpec {
      content(context)
    }
    child = layoutSpec
    let layout = layoutSpec.calculateLayoutThatFits(constrainedSize, restrictedTo: size, relativeToParentSize: parentSize)

    return layout
  }

}
