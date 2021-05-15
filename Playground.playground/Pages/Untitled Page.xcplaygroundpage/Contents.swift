import AsyncDisplayKit
import TextureSwiftSupport

let text1 = ASTextNode()
text1.attributedText = NSAttributedString(string: "Hello")

let text2 = ASTextNode()
text2.attributedText = NSAttributedString(string: "Hello")

let spec = LayoutSpec {
  VStackLayout {
    text1
    text2
  }
}

let layout = ASCalculateRootLayout(spec, ASSizeRangeUnconstrained)
layout.size

print(layout.recursiveDescription())

layout.frame(for: text1)
layout.frame(for: text2)

let layout2 = layout.filteredNodeLayoutTree()

layout2.frame(for: text1)
