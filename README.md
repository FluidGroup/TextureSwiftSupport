# TextureSwiftSupport - Gains up your productivity

This is a library to gain **[Texture(AsyncDisplayKit)](http://texturegroup.org/)** more power in Swift.

* Readable Layout DSL
* Composable components

And you might need to use [`TextureBridging`](https://github.com/TextureCommunity/TextureBridging) to integrate with AutoLayout world in your applications.

## Requirements

Swiift 5.3+

## The cases of usage in Production

- the products of [eureka, Inc](https://eure.jp)
  - [Pairs for Japan](https://apps.apple.com/jp/app/id583376064)
  - [Pairs for Global](https://apps.apple.com/tw/app/id825433065)

## Layout DSL

Using [`resultBuilders`](https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md), `ASLayoutSpec` can be more simply and readable it's like SwiftUI's decralations.

> 🕺🏻 [You want to use this in AutoLayout? ](https://github.com/muukii/MondrianLayout)

**Before**

```swift

override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

  ASStackLayoutSpec(
    direction: .vertical,
    spacing: 0,
    justifyContent: .start,
    alignItems: .start,
    children: [
      self.textNode1,
      self.textNode2,
      self.textNode3,
    ]
  )
  
}
```

**After**

```swift
override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

  LayoutSpec {
    VStackLayout {
      self.textNode1
      self.textNode2
      self.textNode3
    }
  }
  
}
```

Wrapping with `LayoutSpec` enables us to write DSL inside this block.


**More complicated example**

```swift
LayoutSpec {
  if flag {
    VStackLayout {
      HStackLayout(justifyContent: .center) {
        iconNode
          .padding(.top, 24)
          .padding(.bottom, 16)
      }
      .background(gradientNode)
    }
  } else {
    gradientNode
  }
}
```

> ⚠️ Please take care of the differences between this DSL and SwiftUI.  
> This DSL just describes the node's layout. You should avoid to create a new node inside layout.  
> Since `layoutSpecThatFits` would be called multiple times.

### Layouts

* Basic Layouts
  * **VStackLayout**
  * **HStackLayout**
  * **ZStackLayout**
  * **WrapperLayout**
  * **AbsoluteLayout**
  * **CenterLayout**
  * **RelativeLayout**
  * **InsetLayout**
  * **OverlayLayout**
  * **BackgroundLayout**
  * **AspectRatioLayout**
  * **SpacerLayout**

* Advanced Layouts
  * **VGridLayout**
  * **AnyLayout**
  * **Switch**

### Modifiers

- WIP

## Composable components

`TextureSwiftSupport` provides us a lot of components that help to create a new component with compositioning from small components.

Technically, composing increases a number of view or layer in run-time. It might reduce the performance a bit.  
But most of the cases, that won't be matters.

* MaskingNode
* BackgroundNode
* OverlayNode
* PaddingNode
* WrapperCellNode
* WrapperNode
* ShapeLayerNode
* ShapeRenderingNode
* InteractiveNode
* AnyDisplayNode
* GradientNode

## Installation

### CocoaPods

```ruby
pod 'TextureSwiftSupport'
```

> ☝️ Technically, podspec describes multiple subspecs, you can install a part of this library what you want.

## Author

Muukii <muukii.app@gmail.com>
