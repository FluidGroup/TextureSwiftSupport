//
//  Condition.swift
//  TextureSwiftSupport
//
//  Created by muukii on 2020/05/07.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation
import AsyncDisplayKit

public final class LayoutTrait {
   
  public let constraintSize: ASSizeRange

  internal init(constraintSize: ASSizeRange) {
    self.constraintSize = constraintSize
  }
}

/// A condition to lay children out
public struct LayoutCondition {
  
  private let closure: (LayoutTrait) -> Bool
    
  /// - Parameter closure: Make sure a operation can perform thread-safety due to closure runs in any thread.
  public init(_ closure: @escaping (LayoutTrait) -> Bool) {
    self.closure = closure
  }
  
  public func matches(trait: LayoutTrait) -> Bool {
    closure(trait)
  }
}

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
    
    guard condition.matches(trait: .init(constraintSize: constrainedSize)) else {
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
        
    let trait = LayoutTrait(constraintSize: constrainedSize)
    
    for _case in cases {
      if _case.condition.matches(trait: trait) {
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
