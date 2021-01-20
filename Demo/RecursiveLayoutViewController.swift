//
//  RecursiveLayoutViewController.swift
//  Demo
//
//  Created by Muukii on 2021/01/19.
//  Copyright © 2021 muukii. All rights reserved.
//

import Foundation

import GlossButtonNode
import TextureSwiftSupport
import TypedTextAttributes

final class RecursiveLayoutViewController: DisplayNodeViewController {
  private let nodes = (0 ..< 10).map { _ in WrapperNode { ElasticNode() } }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
  }

  override func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      VStackLayout {
        nodes
      }
    }
  }
}

extension RecursiveLayoutViewController {
  final class ElasticNode: ASDisplayNode {
    private let button = GlossButtonNode()
    private var flag = false

    private let textNode = Mocks.ButtonNode()
    private let textNode2 = Mocks.ButtonNode()

    override init() {
      super.init()

      automaticallyManagesSubnodes = true

      button.setDescriptor(
        .init(
          title: "Tap".attributed { TextAttributes() },
          bodyStyle: .init(layout: .vertical()),
          surfaceStyle: .fill(
            .init(
              cornerRound: .circle,
              backgroundColor: .fill(.white), dropShadow: nil
            )
          )
        ),
        for: .normal
      )

      button.onTap = { [weak self] in

        guard let self = self else { return }

        self.flag.toggle()
        #if false
        UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
          self.setNeedsLayout()
          self.layoutIfNeeded()
          self.supernode?.view.window?.setNeedsLayout()
          self.supernode?.view.window?.layoutIfNeeded()
        }
        .startAnimation()

        #else
        self.transitionLayout(
          withAnimation: true,
          shouldMeasureAsync: false,
          measurementCompletion: nil
        )
//        self.supernode?.setNeedsLayout()
//        self.supernode?.layoutIfNeeded()

        #endif
      }
    }

//    override func animateLayoutTransition(_ context: ASContextTransitioning) {
//
//      let a = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
//        self.supernode?.layoutIfNeeded()
//        self.layoutIfNeeded()
//      }
//
//      a.addCompletion { (_) in
//        context.completeTransition(true)
//      }
//
//      a.startAnimation()
//
//    }

    override func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
      LayoutSpec {
        VStackLayout {
          button
          textNode
          if flag {
            textNode2
          }
        }
      }
    }
  }
}
