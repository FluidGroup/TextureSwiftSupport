import AsyncDisplayKit
import TextureSwiftSupport

let text1 = ASTextNode()
text1.attributedText = NSAttributedString(string: "Hello")

let text2 = ASTextNode()
text2.attributedText = NSAttributedString(string: "Hello")

let body = AnyDisplayNode { node, _ in
  LayoutSpec {
    HStackLayout {
      node._makeNode {
        ASTextNode()
      }
      node._makeNode {
        ASTextNode()
      }
    }
  }
}

let spec = LayoutSpec {
  VStackLayout {
    text1
    text2
    body
  }
}

let layout = ASCalculateRootLayout(spec, ASSizeRangeUnconstrained)
layout.size
layout.layoutElement

print(layout.recursiveDescription())

layout.frame(for: text1)
layout.frame(for: text2)

let layout2 = layout.filteredNodeLayoutTree()
print(layout2.recursiveDescription())
layout2.layoutElement
layout2.frame(for: text1)
