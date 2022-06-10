import GlossButtonNode
import StorybookKit
import StorybookKitTextureSupport
import SwiftUI
import TextureSwiftSupport

@available(iOS 13, *)
extension Book {
  static var hostingCellNode: some BookView {
    BookNavigationLink(title: "HostingCellNode") {
      BookNodePreview(expandsWidth: true, preservedHeight: 300) {
        let node = BodyNode()
        node.style.height = .init(unit: .points, value: 300)
        return node
      }
    }
  }
}

private final class CollectionNode: ASCollectionNode {}

@available(iOS 13, *)
private final class BodyNode: ASDisplayNode, ASCollectionDelegateFlowLayout, ASCollectionDataSource {
  let items = (0 ..< 100).map { _ in
    Item(text: BookGenerator.loremIpsum(length: 10))
  }

  let collectionNode: CollectionNode

  override init() {
    let layout = UICollectionViewFlowLayout()

    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = .zero

    collectionNode = .init(collectionViewLayout: layout)

    super.init()

    automaticallyManagesSubnodes = true
  }

  override func didLoad() {
    super.didLoad()

    collectionNode.delegate = self
    collectionNode.dataSource = self
  }

  override func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      collectionNode
    }
  }

  func numberOfSections(in _: ASCollectionNode) -> Int {
    1
  }

  func collectionNode(_: ASCollectionNode, numberOfItemsInSection _: Int) -> Int {
    items.count
  }

  func collectionNode(_: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    let item = items[indexPath.item]

    return {
      if false {
        let textNode = ASTextNode()
        textNode.attributedText = item.text.styled(.init())

        var isOn = false
        let button = GlossButtonNode.simpleButton(title: "toggle") {
          isOn.toggle()

          if isOn {
            textNode.attributedText = "a\n\na".styled(.init())
          } else {
            textNode.attributedText = item.text.styled(.init())
          }
        }
        return WrapperCellNode(
          content: AnyDisplayNode { _, _ in
            LayoutSpec {
              VStackLayout {
                textNode
                button
              }
            }
          }
        )
      }

      return HostingCellNode { state in
        VStack {
          SwiftUICell(state: state, name: item.text)
        }
      }
    }
  }

  func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt _: IndexPath) -> ASSizeRange {
    ASSizeRange(width: collectionNode.bounds.width, height: 0 ... .greatestFiniteMagnitude)
  }
}

@available(iOS 13.0, *)
private struct InteractiveView: View {
  @State var isOn: Bool = false

  var body: some View {
    Button("toggle") {
      isOn.toggle()
    }
    if isOn {
      Color.gray.frame(height: 30)
    }
  }
}

struct Item: Hashable, Identifiable {
  var id: UUID = .init()

  let text: String
}

@available(iOS 13.0, *)
struct SwiftUICell: View {
  let state: HostingCellNode.State
  let name: String
  
  @State var isOn = true
  
  var body: some View {
    HStack {
      Text(name)
        .font(.system(size: 20, weight: .heavy, design: .serif))
      VStack {
        HStack(spacing: -50) {
          Circle()
            .frame(width: 40, height: 40)
            .foregroundColor(.pink)
            .blur(
              radius: {
                if state.isHighlighted {
                  return 20
                } else {
                  return 0
                }
              }()
            )
          
          Circle()
            .frame(width: 40, height: 40)
            .foregroundColor(.blue)
            .blur(radius: state.isHighlighted ? 20 : 0)
        }
        
        if isOn {
          Text("Hi!")
        }
        
        Button("Toggle") {
          isOn.toggle()
        }
      }
    }
    .padding(50)
    .background(Rectangle().border(isOn ? .blue : .gray, width: 8).foregroundColor(.clear))
    .background(Rectangle().border(.pink, width: 30).foregroundColor(.clear))
    .animation(.interactiveSpring())
  }
  }
