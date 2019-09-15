# TextureSwiftSupport

TextureSwiftSupport is a support library for [Texture](http://texturegroup.org/)<br>
It helps writing the code in Texture with Swift's power.

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
    LayoutSpec {
        VStackLayout {
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
    LayoutSpec {
        VStackLayout {
            HStackLayout {
                InsetLayout {
                    node1
                }
                InsetLayout {
                    node2
                }
            }
            node3
            HStackLayout {
                node4,
                node5,
                node6,
            }
        }
    }
}
```

## Layout Specs

* VStackLayout
* HStackLayout
* ZStackLayout
* InsetLayout
* OverlayLayout
* BackgroundLayout
* AspectRatioLayout

## Author

Muukii <muukii.app@gmail.com>
