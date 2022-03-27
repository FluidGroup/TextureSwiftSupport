//
//  CornerLayout.swift
//  TextureSwiftSupport
//
//  Created by arya.cia on 14/03/22.
//  Copyright © 2022 muukii. All rights reserved.
//

import Foundation

public struct CornerLayout<CornerContent, Content> : _ASLayoutElementType where CornerContent : _ASLayoutElementType, Content : _ASLayoutElementType {

  public let content: Content
  public let cornerContent: CornerContent
  public let location: ASCornerLayoutLocation
  
  public init(
    child: Content,
    corner: CornerContent,
    location: ASCornerLayoutLocation
  ) {
    self.content = child
    self.cornerContent = corner
    self.location = location
  }
  
  public func tss_make() -> [ASLayoutElement] {
    [
      ASCornerLayoutSpec(
        child: content.tss_make().first!,
        corner: cornerContent.tss_make().first ?? ASLayoutSpec(),
        location: self.location
      )
    ]
  }
}
