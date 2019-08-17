# TextureSwiftSupport

TextureSwiftSupport is a support library for [Texture](http://texturegroup.org/)<br>
It helps writing the code iin Texture with Swift's power.

## Requirements

Swiift 5.1+

## LayoutSpecBuilder (Using \_functionBuidler)

Swift5.1 has FunctionBuilder(it's not officially)<br>
With this, we can write layout spec with no more commas. (It's like SwiftUI)

### Plain

```swift

override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASStackLayoutSpec(
        direction: .vertical,
        spacing: 0,
        justifyContent: .start,
        alignItems: .start,
        children: [
            textNode1,
            textNode2,
            textNode3,
        ]
    )
}
```

### With TextureSwiftSupport

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    AS.LayoutSpec {
        AS.VStack {
            textNode1
            textNode2
            textNode3
        }
    }
}
```

More example

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    AS.LayoutSpec {
        AS.VStack {
            AS.HStack {
                AS.Inset {
                    node1
                }
                AS.Inset {
                    node2
                }
            }
            node3
            AS.HStack {
                node4,
                node5,
                node6,
            }
        }
    }
}
```

## Author

Muukii <muukii.app@gmail.com>
