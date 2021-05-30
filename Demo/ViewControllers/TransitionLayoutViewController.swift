//
//  TransitionLayoutViewController.swift
//  Demo
//
//  Created by Muukii on 2021/05/15.
//  Copyright © 2021 muukii. All rights reserved.
//

import Foundation

import TextureSwiftSupport
import GlossButtonNode
import TypedTextAttributes

/**
 Does not work
 https://github.com/TextureGroup/Texture/issues/1995
 */
final class TransitionLayoutViewController: DisplayNodeViewController {

  private let contentNode = ContentNode()

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    LayoutSpec {
      VStackLayout {
        contentNode
        HStackLayout {
          node._makeNode {
            GlossButtonNode.simpleButton(title: "Large") { [unowned self] in
              contentNode.large()
            }
          }
          node._makeNode {
            GlossButtonNode.simpleButton(title: "Small") { [unowned self] in
              contentNode.small()
            }
          }
        }
      }
      .padding(node.capturedSafeAreaInsets)
    }
  }

  private final class ContentNode: NamedDisplayNodeBase {

    private enum LayoutMode {
      case large
      case small
    }

    private let imageNode = Mocks.ImageNode()

    struct SmallComponents {
      let titleNode = ASTextNode()
      let artistNameNode = ASTextNode()
    }

    struct LargeComponents {
      let titleNode = ASTextNode()
      let artistNameNode = ASTextNode()
    }

    private let smallComponents = SmallComponents()
    private let largeComponents = LargeComponents()

    private var layoutMode: LayoutMode = .large

    private var animateBlock: () -> Void = {}

    override init() {
      super.init()

      addSubnode(imageNode)
      addSubnode(smallComponents.titleNode)
      addSubnode(smallComponents.artistNameNode)

      addSubnode(largeComponents.titleNode)
      addSubnode(largeComponents.artistNameNode)

//      automaticallyManagesSubnodes = true

      smallComponents.titleNode.attributedText = "Mosaik".styled {
        $0.font(.preferredFont(forTextStyle: .headline))
      }

      smallComponents.artistNameNode.attributedText = "Township Rebelion".styled {
        $0.font(.preferredFont(forTextStyle: .headline))
      }

      largeComponents.titleNode.attributedText = "Mosaik".styled {
        $0.font(.preferredFont(forTextStyle: .headline))
      }

      largeComponents.artistNameNode.attributedText = "Township Rebelion".styled {
        $0.font(.preferredFont(forTextStyle: .headline))
      }

    }

    override func didLoad() {
      super.didLoad()

      large()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      LayoutSpec {
        switch layoutMode {
        case .small:
          HStackLayout {
            imageNode
              .aspectRatio(1)
              .width(55)

            SpacerLayout(minLength: 16, flexGrow: 0)

            VStackLayout(alignItems: .start) {
              smallComponents.titleNode
              smallComponents.artistNameNode
            }
          }
        case .large:

          VStackLayout {
            imageNode
              .aspectRatio(1)

            VStackLayout(alignItems: .start) {
              largeComponents.titleNode
              largeComponents.artistNameNode
            }
          }
        }
      }
    }

    func large() {
      layoutMode = .large
      UIViewPropertyAnimator(duration: 2, dampingRatio: 0.9) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
      }
      .startAnimation()

    }

    func small() {
      layoutMode = .small

      UIViewPropertyAnimator(duration: 2, dampingRatio: 0.9) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
      }
      .startAnimation()

    }

//    override func animateLayoutTransition(_ context: ASContextTransitioning) {
//      print("xxx", context)
//      animateBlock()
//      animateBlock = {}
//    }
  }

}
