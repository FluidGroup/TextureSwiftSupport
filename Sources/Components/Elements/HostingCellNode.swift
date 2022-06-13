#if canImport(SwiftUI)
import AsyncDisplayKit
import SwiftUI

@available(iOS 13, *)
public final class HostingCellNode: ASCellNode {
  override public final var isSelected: Bool {
    didSet {
      if proxy.state.isSelected != isSelected {
        proxy.state.isSelected = isSelected
      }
    }
  }

  override public final var isHighlighted: Bool {
    didSet {
      if proxy.state.isHighlighted != isHighlighted {
        proxy.state.isHighlighted = isHighlighted
      }
    }
  }

  private let proxy: Proxy<State> = .init(state: .init())

  private let contentNode: ContentNode

  // MARK: - Init

  override public init() {
    contentNode = .init(proxy: proxy)

    super.init()

    automaticallyManagesSubnodes = true
  }

  public convenience init<Content: View>(@ViewBuilder content: @escaping (State) -> Content) {
    self.init()
    contentNode.setContent(content: content)
  }

  override public func didLoad() {
    super.didLoad()
  }

  override public func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
    ASWrapperLayoutSpec(layoutElement: contentNode)
  }

  // MARK: -

  public final func setContent<Content: SwiftUI.View>(
    @ViewBuilder content: @escaping (State) -> Content
  ) {
    contentNode.setContent(content: content)
  }
}

@available(iOS 13, *)
extension HostingCellNode {
  public struct State {
    public var isSelected: Bool
    public var isHighlighted: Bool

    public init(isSelected: Bool = false, isHighlighted: Bool = false) {
      self.isSelected = isSelected
      self.isHighlighted = isHighlighted
    }
  }

  final class ContentNode: ASDisplayNode {
    /// won't be loaded until didLoad
    private var hostingController: HostingController<RootView<State>>!

    private let proxy: Proxy<State>

    // MARK: - Init

    init(proxy: Proxy<State>) {
      self.proxy = proxy

      super.init()

      setViewBlock { [unowned self] in

        self.hostingController = HostingController(
          rootView: RootView(proxy: proxy)
        )

        self.hostingController.onInvalidated = { [weak self] in
          guard let self = self else { return }
          self.setNeedsLayout()
          self.supernode?.setNeedsLayout()
        }

        return self.hostingController.view
      }
    }

    // MARK: -

    final func setContent<Content: SwiftUI.View>(
      @ViewBuilder content: @escaping (State) -> Content
    ) {
      proxy.content = { state in
        SwiftUI.AnyView(content(state))
      }
    }

    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
      hostingController?.sizeThatFits(in: constrainedSize) ?? .init(width: 1, height: 1)
    }
  }
}
#endif
