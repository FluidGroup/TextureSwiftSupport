//
// Copyright (c) 2020 Hiroshi Kimura(Muukii) <muuki.app@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public struct GridLayoutItem {

  /// The size in the minor axis of one or more rows or columns in a grid
  /// layout.
  public enum Size {
    /// A single item with the specified fixed size.
    case fixed(CGFloat)

    /// A single flexible item.
    ///
    /// The size of this item is the size of the grid with spacing and
    /// inflexible items removed, divided by the number of flexible items,
    /// clamped to the provided bounds.
    case flexible(minimum: CGFloat = 10, maximum: CGFloat = .infinity)
  }

  /// The size of the item, which is the width of a column item or the
  /// height of a row item.
  public var size: Size

  /// The spacing to the next item.
  public var spacing: CGFloat = 0

  public init(_ size: Size = .flexible(), spacing: CGFloat = 0) {
    self.size = size
    self.spacing = spacing
  }

}

public struct VGridLayout<Content> : _ASLayoutElementType where Content : _ASLayoutElementType {

  private let content: Content
  private let columns: [GridLayoutItem]
  private let spacing: CGFloat
  private let isConcurrent: Bool

  /// Creates an instance
  ///
  /// - Parameters:
  ///   - columns:
  ///   - spacing: The spacing to the next item.
  ///   - isConcurrent: A Boolean value that indicates whether the stack layout lays it out with concurrently calculating the size of the element.
  ///   - content:
  public init(
    columns: [GridLayoutItem],
    spacing: CGFloat = 0,
    isConcurrent: Bool = false,
    content: () -> Content
  ) {

    self.content = content()
    self.columns = columns
    self.spacing = spacing
    self.isConcurrent = isConcurrent
  }

  public func tss_make() -> [ASLayoutElement] {

    let columnCount = columns.count
    let contents = content.tss_make()

    /**
     Adds padding layout specs to display as grid
     */
    let v = contents.count % columnCount
    let emptySpecs = v >= 1 ? (0..<(columnCount - v)).map { _ in ASLayoutSpec() } : []

    let rows = (contents + emptySpecs)
      .chunked(into: columnCount)
      .enumerated()
      .map { (row, slice) -> HStackLayout<[ASWrapperLayoutSpec]> in

        let layoutElements = slice
          .enumerated()
          .map { i, e -> ASWrapperLayoutSpec in

            let spec = ASWrapperLayoutSpec(layoutElement: e)

            applyItem: do {

              let gridItem = columns[i]

              if i < columns.indices.upperBound {
                spec.style.spacingAfter = gridItem.spacing
              }

              switch gridItem.size {
              case .fixed(let length):

                spec.style.width = ASDimension(unit: .points, value: length)
                spec.style.flexShrink = 0

              case .flexible(let minimum, let maximum):

                if minimum == .infinity {
                  spec.style.minWidth = ASDimensionAuto
                } else {
                  spec.style.minWidth = ASDimension(unit: .points, value: minimum)
                }

                if maximum == .infinity {
                  spec.style.maxWidth = ASDimensionAuto
                } else {
                  spec.style.maxWidth = ASDimension(unit: .points, value: minimum)
                }

                spec.style.width = ASDimension(unit: .fraction, value: 1)
                spec.style.flexShrink = 1
              }

            }

            return spec
          }

        let layout = HStackLayout(
          spacing: 0,
          justifyContent: .spaceBetween,
          alignItems: .stretch,
          isConcurrent: isConcurrent
        ) {
          layoutElements
        }

        return layout
      }

    return [
      LayoutSpec {
        VStackLayout(
          spacing: spacing,
          justifyContent: .start,
          alignItems: .stretch,
          flexWrap: .noWrap,
          isConcurrent: isConcurrent
        ) {
          rows
        }
      }
    ]
  }
}

extension Collection where Index == Int {

  fileprivate func chunked(into size: Index) -> [Self.SubSequence] {
    stride(from: 0, to: count, by: size).map {
      self[$0 ..< Swift.min($0 + size, count)]
    }
  }

}

