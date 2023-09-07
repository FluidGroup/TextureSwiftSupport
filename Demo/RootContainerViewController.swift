import StorybookKit
import UIKit

final class RootContainerViewController: UIViewController {

  init() {
    super.init(nibName: nil, bundle: nil)

    let container = UIHostingController(rootView: StorybookDisplayRootView(bookStore: .init(book: book)))

    addChild(container)
    view.addSubview(container.view)
    container.view.frame = view.bounds
    container.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
