
/// A container display node that handles itself appears on the device screen.
/// Underlying, using CATiledLayer to hook the signal of appearing.
public final class OnAppearNode<Content: ASDisplayNode>: NamedDisplayCellNodeBase {

  public struct Handlers {
    /// Runs only once on appear.
    public var onAppear: () -> Void = {}
  }

  public override var supportsLayerBacking: Bool {
    false
  }

  public var handlers = Handlers()
  public let content: Content
  private var debug: Bool = false

  private var hasAppeared = false

  #if DEBUG
  private lazy var debuggingNode = DebuggingNode()
  #endif

  private let tiledLayerNode = ViewNode<TiledLayerView> { .init() }

  /// Creates an instance
  /// - Parameters:
  ///   - debug: Shows debugging indicators as an overlay
  ///   - content:
  public init(
    debug: Bool = false,
    content: () -> Content
  ) {

    #if DEBUG
    self.debug = debug
    #endif

    self.content = content()

    super.init()

    automaticallyManagesSubnodes = true
  }

  public override func didLoad() {
    super.didLoad()

    tiledLayerNode.wrappedView.setOnDraw { [weak self] in
      guard let self = self else { return }
      guard self.hasAppeared == false else { return }
      self.hasAppeared = true
      self.handlers.onAppear()

      #if DEBUG
      if self.debug {
        self.debuggingNode.setText("Appeared")
      }
      #endif
    }
  }

  public final override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    #if DEBUG
    return LayoutSpec {
      if debug {
        ZStackLayout {
          content
            .overlay(debuggingNode)
          tiledLayerNode.preferredSize(.init(width: 1, height: 1))
            .relativePosition(horizontal: .start, vertical: .start)
        }
      } else {
        ZStackLayout {
          content
          tiledLayerNode.preferredSize(.init(width: 1, height: 1))
            .relativePosition(horizontal: .start, vertical: .start)
        }
      }
    }
    #else
    return LayoutSpec {
      ZStackLayout {
        content
        tiledLayerNode.preferredSize(.init(width: 1, height: 1))
          .relativePosition(horizontal: .start, vertical: .start)
      }
    }
    #endif

  }

  @discardableResult
  public func onAppear(_ closure: @escaping () -> Void) -> Self {
    handlers.onAppear = closure
    return self
  }

  #if DEBUG

  private final class DebuggingNode: NamedDisplayNodeBase {

    private let textNode = ASTextNode()

    override init() {
      super.init()

      backgroundColor = .init(white: 0.8, alpha: 0.8)

      automaticallyManagesSubnodes = true

      isUserInteractionEnabled = false
    }

    func setText(_ text: String) {

      textNode.attributedText = NSAttributedString(
        string: text,
        attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.systemFont(ofSize: 18)]
      )
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      LayoutSpec {
        HStackLayout {
          textNode
        }
      }
    }
  }

  #endif
}

private final class TiledLayerView: UIView {

  override class var layerClass: AnyClass {
    TiledLayer.self
  }

  init() {
    super.init(frame: .zero)

    isOpaque = false
    backgroundColor = .clear
  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

    let view = super.hitTest(point, with: event)

    if view == self {

      return nil
    }
    return view
  }

  func setOnDraw(_ closure: @escaping () -> Void) {
    (layer as! TiledLayer).onDraw = closure
  }
}

private final class TiledLayer: CATiledLayer {

  var onDraw: () -> Void = {}

  override class func fadeDuration() -> CFTimeInterval {
    0
  }

  override func draw(in ctx: CGContext) {
    if Thread.isMainThread {
      onDraw()
    } else {
      DispatchQueue.main.async(execute: onDraw)
    }
  }
}
