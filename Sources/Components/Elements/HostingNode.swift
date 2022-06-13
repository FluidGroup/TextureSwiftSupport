#if canImport(SwiftUI)

import AsyncDisplayKit
import SwiftUI

@available(iOS 13, *)
final class Proxy<State>: ObservableObject {
  @Published var state: State
  @Published var content: (State) -> SwiftUI.AnyView? = { _ in nil }
  
  init(state: State) {
    self.state = state
  }
}

@available(iOS 13, *)
struct RootView<State>: SwiftUI.View {
  @ObservedObject var proxy: Proxy<State>
  
  var body: some View {
    proxy.content(proxy.state)
  }
}

@available(iOS 13, *)
public final class HostingNode: ASDisplayNode {
  
  public struct State {}
  
  public override var supportsLayerBacking: Bool {
    return false
  }

  private var hostingController: HostingController<RootView<State>>!

  private let proxy: Proxy<State> = .init(state: .init())

  override public init() {
    super.init()

    hostingController = HostingController(
      rootView: RootView(proxy: proxy)
    )

    setViewBlock { [unowned self] in
      hostingController.view
    }

    hostingController.onInvalidated = { [weak self] in
      guard let self = self else { return }
      self.setNeedsLayout()
      self.supernode?.setNeedsLayout()
    }
  }

  public convenience init<Content: View>(@ViewBuilder content: @escaping (State) -> Content) {
    self.init()
    setContent(content: content)
  }

  // MARK: -

  public final func setContent<Content: SwiftUI.View>(
    @ViewBuilder content: @escaping (State) -> Content
  ) {
    proxy.content = { state in
      SwiftUI.AnyView(content(state))
    }
  }

  override public func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
    hostingController.sizeThatFits(in: constrainedSize)
  }

  override public func didEnterHierarchy() {
    super.didEnterHierarchy()

    if let _ = view.window {
      if let parentViewController = view.findNearestViewController() {
        parentViewController.addChild(hostingController)
        hostingController.didMove(toParent: parentViewController)
      } else {
        assertionFailure()
      }
    } else {
      assertionFailure()
    }
  }

  override public func didExitHierarchy() {
    super.didExitHierarchy()

    // https://muukii.notion.site/Why-we-need-to-add-UIHostingController-to-view-controller-chain-14de20041c99499d803f5a877c9a1dd1

    hostingController.willMove(toParent: nil)
    hostingController.removeFromParent()
  }
}

@available(iOS 13, *)
final class HostingController<Content: View>: UIHostingController<Content> {
  private var _intrinsicContentSize: CGSize?

  var onInvalidated: () -> Void = {}

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    do {
      if _intrinsicContentSize != view.intrinsicContentSize {
        _intrinsicContentSize = view.intrinsicContentSize
        view.invalidateIntrinsicContentSize()
        onInvalidated()
      }
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
}

#endif
