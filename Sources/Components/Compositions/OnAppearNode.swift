/// A container display node that handles itself appears on the device screen.
/// Underlying, using CATiledLayer to hook the signal of appearing.
public final class OnAppearNode<Content: ASDisplayNode>: NamedDisplayCellNodeBase {

  private struct State: Equatable {
    var flagTopLeft = false
    var flagBottomRight = false
    
    var hasAppeared = false

  }

  public struct Handlers {
    /// Runs only once on appear.
    public var onAppear: @MainActor () -> Void = {}
  }

  public override var supportsLayerBacking: Bool {
    false
  }

  public var handlers = Handlers()
  public let content: Content
  private var debug: Bool = false


  #if DEBUG
  private lazy var debuggingNode = DebuggingNode()
  #endif

  private var topLeftTiledLayerNode: ViewNode<TiledLayerView>?
  private var bottomRightTiledLayerNode: ViewNode<TiledLayerView>?

  @MainActor
  private var state = State() {
    didSet {
      guard oldValue != state else {
        return
      }
      update(state: state, old: oldValue)
    }
  }

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
    
    reset()

  }

  @MainActor
  private func reset() {
    
    state = .init()
    
    bottomRightTiledLayerNode = .init(wrappedView: { .init() })
    topLeftTiledLayerNode = .init(wrappedView: { .init() })
    
    setNeedsLayout()
        
    bottomRightTiledLayerNode!.wrappedView.setOnDraw { [weak self] in
      guard let self else { return }
      guard self.state.flagBottomRight == false else { return }
      self.state.flagBottomRight = true
    }
    
    topLeftTiledLayerNode!.wrappedView.setOnDraw { [weak self] in
      guard let self else { return }
      guard self.state.flagTopLeft == false else { return }
      self.state.flagTopLeft = true
    }
    
  }
  
  @MainActor
  private func update(state: State, old: State?) {
        
#if DEBUG
    if self.debug {
      self.debuggingNode.setText("[\(state.flagTopLeft), \(state.flagBottomRight)]")
    }
#endif
        
    if state.hasAppeared == false, state.flagBottomRight, state.flagTopLeft {
      self.state.hasAppeared = true
      handlers.onAppear()
    }
  }

  public final override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    #if DEBUG
    if debug {
      return LayoutSpec {
        content
          .overlay(
            ZStackLayout {
              debuggingNode
              topLeftTiledLayerNode.preferredSize(.init(width: 1, height: 1))
                .relativePosition(horizontal: .start, vertical: .start)
              bottomRightTiledLayerNode.preferredSize(.init(width: 1, height: 1))
                .relativePosition(horizontal: .end, vertical: .end)
            }
          )
      }
    }
    #endif

    return LayoutSpec {
      content
        .overlay(
          ZStackLayout {
            topLeftTiledLayerNode.preferredSize(.init(width: 1, height: 1))
              .relativePosition(horizontal: .start, vertical: .start)
            bottomRightTiledLayerNode.preferredSize(.init(width: 1, height: 1))
              .relativePosition(horizontal: .end, vertical: .end)
          }
        )
    }

  }

  @discardableResult
  public func onAppear(_ closure: @escaping @MainActor () -> Void) -> Self {
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

    (layer as! TiledLayer).drawsAsynchronously = true
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

  func setOnDraw(_ closure: @escaping @MainActor () -> Void) {
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
