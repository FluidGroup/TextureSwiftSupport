# TextureSwiftSupport

TextureSwiftSupport is a support library for [Texture](http://texturegroup.org/)<br>
It helps writing the code in Texture with Swift's power.

## Requirements

Swiift 5.1+

## The cases of usage in Production

- the products of [eureka, Inc](https://eure.jp)
  - [Pairs for Japan](https://apps.apple.com/jp/app/id583376064)
  - [Pairs for Global](https://apps.apple.com/tw/app/id825433065)

## LayoutSpecBuilder (Using @_functionBuidler)

Swift5.1 has FunctionBuilder(it's not officially)<br>
With this, we can write layout spec with no more commas. (It's like SwiftUI)

**Plain**

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

**With LayoutSpecBuilder**

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

**More complicated** 

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

**SwiftUI-like Method Chain API**

Inspiring from SwiftUI.

We can build a node hierarchy with the method chain.

For now, we have only a few methods. (e.g Padding, Overlay, Background)

```swift
textNode
  .padding([.vertical], padding: 4)
  .background(backgroundNode)
```

- About Function builders
  - [`Function builders`](https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md) is a feature in Swift Language.<br>
For example, SwiftUI uses it.

  - [Implementation example](https://github.com/apple/swift/blob/23f707227608d885f1f4172458abca7f63e3b2c2/test/Constraints/function_builder_diags.swift)
  
### PropertyWrappers

- `@_NodeLayout`

It calls setNeedsLayout() automatically when wrappedValue changed. (⚠️ Experimental Feature)
If we set any node to bodyNode, MyNode will relayout automatically.

```swift
final class MyNode: ASDisplayNode {

  @_NodeLayout bodyNode: ASDisplayNode?

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    LayoutSpec {
      VStackLayout {
        bodyNode
        ...
      }
    }
  }
}
```

### Composition container

Composition container composes one or more nodes in the container node.
It would be helpful when a node needs to adjust in specific use-cases.

Example

```swift
let myNode: MyNode = 

let paddedNode: PaddingNode<MyNode> = PaddingNode(
  padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
) {
  myNode
}
```

```swift

let myNode: MyNode = 
let gradientNode: MyGradientNode

let composedNode = BackgroundNode(
  child: { myNode },
  background: { gradientNode }
)
```

### Shape display node

* ShapeLayerNode
  * Uses CALayer to draw
* ShapeRenderingNode
  * Uses CoreGraphics to draw

## Author

Muukii <muukii.app@gmail.com>
