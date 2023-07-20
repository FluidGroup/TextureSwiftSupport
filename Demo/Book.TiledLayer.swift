import StorybookKit
import MondrianLayout
import UIKit

extension Book {

  @MainActor
  static func tiledLayer() -> BookView {

    BookNavigationLink(title: "Tile") {

      BookNavigationLink(title: "TiledLayerView") {

        BookForEach(data: 0..<50) { i in
          BookPreview {
            with(TiledLayerView(identifier: i)) { view in
              view.backgroundColor = .systemYellow
              Mondrian.layout {
                view.mondrian.layout.size(.init(width: 60, height: 60))
              }
            }
          }
        }

      }

      BookNavigationLink(title: "TiledLayerView - transparent") {

        BookForEach(data: 0..<50) { i in
          BookPreview {

            ZStackView(views: [
              with(UIButton(type: .system)) {
                $0.setTitle("Hello", for: .normal)
              },
              with(TiledLayerView(identifier: i)) { view in
                view.alpha = 1
                view.isOpaque = false
                Mondrian.layout {
                  view.mondrian.layout.size(.init(width: 60, height: 60))
                }
              },
            ])

          }
        }

      }

      BookNavigationLink(title: "TiledLayerView - hiding") {

        BookForEach(data: 0..<50) { i in
          BookPreview {
            ZStackView(views: [
              with(TiledLayerView(identifier: i)) { view in
                view.backgroundColor = .systemYellow
                Mondrian.layout {
                  view.mondrian.layout.size(.init(width: 60, height: 60))
                }
              },
              with(UIView()) { view in
                view.backgroundColor = .systemYellow
                Mondrian.layout {
                  view.mondrian.layout.size(.init(width: 60, height: 60))
                }
              },
            ])
          }
          .addButton("On") { view in
            view.subviews[1].isHidden = true
          }
        }

      }

    }

  }
}

fileprivate final class TiledLayerView: UIView {

  let identifier: Int

  init(
    identifier: Int
  ) {
    self.identifier = identifier
    super.init(frame: .zero)

    (layer as! TiledLayer).identifier = identifier
  }

  required init?(
    coder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

  override class var layerClass: AnyClass {
    TiledLayer.self
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

    let view = super.hitTest(point, with: event)

    if view == self {

      return nil
    }
    return view
  }
}

fileprivate final class NonTiledLayerView: UIView {

  override class var layerClass: AnyClass {
    NonTiledLayer.self
  }

}

fileprivate final class TiledLayer: CATiledLayer {

  var identifier: Int?

  override class func fadeDuration() -> CFTimeInterval {
    0
  }

  override func draw(in ctx: CGContext) {

    print("[TiledLayer] Draw \(identifier?.description ?? "null")")
  }
}

fileprivate final class NonTiledLayer: CALayer {

  override func draw(in ctx: CGContext) {
    print("[NonTiledLayer] Draw")
  }
}

