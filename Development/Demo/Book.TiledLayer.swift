import StorybookKit
import MondrianLayout
import UIKit

extension Book {

  @MainActor
  static func tiledLayer() -> BookPage {

    BookPage(title: "Tile") {

      BookPage(title: "TiledLayerView") {

        ForEach(0..<50) { i in
          BookPreview { _ in
            with(TiledLayerView(identifier: i)) { view in
              view.backgroundColor = .systemYellow
              Mondrian.layout {
                view.mondrian.layout.size(.init(width: 60, height: 60))
              }
            }
          }
        }

      }

      BookPage(title: "TiledLayerView - transparent") {

        ForEach(0..<50) { i in
          BookPreview { _ in

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

      BookPage(title: "TiledLayerView - hiding") {

        ForEach(0..<50) { i in
          BookPreview { context in
            let view = ZStackView(views: [
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

            context.control {
              Button("On") {
                view.subviews[1].isHidden = true
              }
            }

            return view
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

