
import SwiftUI
import AsyncDisplayKit
import TextureBridging
import TextureSwiftSupport

enum Preview_Node: PreviewProvider {
  
  private typealias TargetComponent = CustomNode
  
  static var previews: some View {
    
    Group {
      ViewHost(instantiated: NodeView(node: TargetComponent()))
    }
    
  }
  
}

private final class CustomNode: ASDisplayNode {
  
  private let textNode = ASTextNode()
  
  override func didLoad() {
    super.didLoad()
    backgroundColor = .red
    
    textNode.attributedText = "Hello".styled(.init())
    
    automaticallyManagesSubnodes = true
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      textNode
    }
  }
  
}

public struct ViewHost<ContentView: UIView>: UIViewRepresentable {
  
  private let contentView: ContentView
  private let _update: @MainActor (_ uiView: ContentView, _ context: Context) -> Void
  
  public init(
    instantiated: ContentView,
    update: @escaping @MainActor (_ uiView: ContentView, _ context: Context) -> Void = { _, _ in }
  ) {
    self.contentView = instantiated
    self._update = update
  }
  
  public func makeUIView(context: Context) -> ContentView {
    return contentView
  }
  
  public func updateUIView(_ uiView: ContentView, context: Context) {
    _update(uiView, context)
  }
  
}
