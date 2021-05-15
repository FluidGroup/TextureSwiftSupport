//
//  MenuViewController.swift
//  Demo
//
//  Created by muukii on 2020/04/21.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

import AsyncDisplayKit
import TextureSwiftSupport
import GlossButtonNode
import TypedTextAttributes
import FluidPresentation

fileprivate let descriptor = GlossButtonDescriptor(bodyStyle: .init(layout: .horizontal()), surfaceStyle: .bodyOnly)

final class MenuViewController: DisplayNodeViewController {

  private let stackScrollNode = StackScrollNode()

  override init() {
    
    super.init()
    view.backgroundColor = .white
    title = "TextureSwiftSupport"

    stackScrollNode.append(nodes: [
      Components.makeSelectionCell(title: "Instagram post", onTap: { [unowned self] in
        let controller = NavigatedFluidViewController(
          idiom: .navigationPush(isScreenGestureEnabled: false),
          bodyViewController: InstagramPostCellViewController()
        )
        present(controller, animated: true, completion: nil)
      }),

      Components.makeSelectionCell(title: "Adaptive layout", onTap: { [unowned self] in

        let controller = NavigatedFluidViewController(
          idiom: .navigationPush(isScreenGestureEnabled: false),
          bodyViewController: AdaptiveLayoutViewController()
        )
        present(controller, animated: true, completion: nil)
      }),

      Components.makeSelectionCell(title: "Composition", onTap: { [unowned self] in

        let controller = NavigatedFluidViewController(
          idiom: .navigationPush(isScreenGestureEnabled: false),
          bodyViewController: CompositionCatalogViewController()
        )
        present(controller, animated: true, completion: nil)
      }),

      Components.makeSelectionCell(title: "Test recursive layout", onTap: { [unowned self] in
     
        let controller = NavigatedFluidViewController(
          idiom: .navigationPush(isScreenGestureEnabled: false),
          bodyViewController: RecursiveLayoutViewController()
        )
        present(controller, animated: true, completion: nil)
      })

    ])

  }
    
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      stackScrollNode
    }
  }
}
