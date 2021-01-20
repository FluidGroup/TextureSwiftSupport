//
//  InstagramPostCellViewController.swift
//  Demo
//
//  Created by muukii on 2020/04/21.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

import AsyncDisplayKit
import TextureSwiftSupport

final class InstagramPostCellViewController: PlainDisplayNodeViewController {
  
  private let postNode = InstagramPostCellNode()
  
  override init() {
    
    super.init()
    view.backgroundColor = .white
  }
  
  @objc
  private func tapOpenSampleButton() {
    
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      
      VStackLayout {
        postNode
      }
      .padding(capturedSafeAreaInsets)
      
    }
  }
}

private final class InstagramPostCellNode: ASDisplayNode {
  
  private let header: ASDisplayNode
  private let body: ASDisplayNode
  private let footer: ASDisplayNode
  
  override init() {
    
    self.header = Self.makeAuthorHeaderNode(profileImage: .init(), name: "Muukii", onTapMenu: { /* demo */ })
    
    self.body = Self.makeBodyNode(image: .init())
    
    self.footer = Self.makeFooterNode(
      onTapLikeButton: { /* demo */ },
      onTapCommentButton: { /* demo */ },
      onTapShareButton: { /* demo */ },
      onTapSaveButton: { /* demo */ }
    )
    
    super.init()
    
    automaticallyManagesSubnodes = true
       
  }
    
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      VStackLayout {
        header
        body
        footer
      }
    }
  }
}

extension InstagramPostCellNode {
  
  private static func makeAuthorHeaderNode(
    profileImage: UIImage,
    name: String,
    onTapMenu: @escaping () -> Void
  ) -> AnyDisplayNode {
    
    let imageNode = Mocks.CircularImageNode()
    let nameNode = Mocks.SingleLineTextNode()
    let menuNode = Mocks.ThumbNode()
    
    return AnyDisplayNode { _, _ in
      LayoutSpec {
        HStackLayout(alignItems: .center) {
          imageNode
            .preferredSize(.init(width: 38, height: 38))
          nameNode
            .spacingBefore(4)
          HSpacerLayout(minLength: 20)
          menuNode
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
      }
    }
    .onDidLoad {
      $0.backgroundColor = .white
    }
  }
  
  private static func makeBodyNode(image: UIImage) -> ASDisplayNode {
    
    let imageNode = Mocks.ImageNode()
    
    return AnyDisplayNode { _, _ in
      LayoutSpec {
        imageNode
          .aspectRatio(1)
      }
    }
    
  }
    
  private static func makeFooterNode(
    onTapLikeButton: @escaping () -> Void,
    onTapCommentButton: @escaping () -> Void,
    onTapShareButton: @escaping () -> Void,
    onTapSaveButton: @escaping () -> Void
  ) -> AnyDisplayNode {
    
    let likeButtonNode = Mocks.ButtonNode()
    let commentButtonNode = Mocks.ButtonNode()
    let shareButtonNode = Mocks.ButtonNode()
    let saveButtonNode = Mocks.ButtonNode()
    
    likeButtonNode.onTap = onTapLikeButton
    commentButtonNode.onTap = onTapCommentButton
    shareButtonNode.onTap = onTapShareButton
    saveButtonNode.onTap = onTapSaveButton
    
    return AnyDisplayNode { _, _ in
      LayoutSpec {
        HStackLayout(alignItems: .center) {
          likeButtonNode
          commentButtonNode
          shareButtonNode
          HSpacerLayout(minLength: 20)
          saveButtonNode
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
      }
    }
    .onDidLoad {
      $0.backgroundColor = .white
    }
  }
  
  
}
