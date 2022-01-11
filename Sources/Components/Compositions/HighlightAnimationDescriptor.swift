//
// Copyright (c) 2021 Hiroshi Kimura(Muukii) <muukii.app@gmail.com>
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

public struct HighlightAnimationDescriptor {

  public final class Context {

    public typealias Handler = (_ isHighlighted: Bool, _ containerView: UIView, _ bodyView: UIView) -> Void

    public private(set) var overlay: UIView?
    public private(set) var handler: Handler?

    public init() {

    }

    public func setOverlay(_ overlay: UIView) {
      self.overlay = overlay
    }

    public func setHandler(_ handler: @escaping Handler) {
      self.handler = handler
    }
  }

  private let _prepare: (Context) -> Void

  public init(
    prepare: @escaping (Context) -> Void
  ) {
    self._prepare = prepare
  }

  public func prepare() -> Context {
    assert(Thread.isMainThread)
    let context = Context()
    _prepare(context)
    return context
  }
}

extension HighlightAnimationDescriptor {
  public static let noAnimation: Self = .init { _ in }

  ///
  public static let bodyShrink: HighlightAnimationDescriptor = customBodyShrink(
    shrinkingScale: 0.97
  )

  public static func customBodyShrink(
    shrinkingScale: CGFloat
  ) -> HighlightAnimationDescriptor {

    return .init { context in

      context.setHandler { isHighlighted, _, bodyView in
        if isHighlighted {
          UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
              bodyView.transform = .init(scaleX: shrinkingScale, y: shrinkingScale)
            },
            completion: nil
          )
        } else {
          UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
              bodyView.transform = .identity
            },
            completion: nil
          )
        }
      }

    }

  }

  ///
  public static let translucent: HighlightAnimationDescriptor = .init { context in

    context.setHandler { isHighlighted, containerView, bodyView in
      if isHighlighted {
        UIView.animate(
          withDuration: 0.12,
          delay: 0,
          options: [.beginFromCurrentState, .curveEaseIn, .allowUserInteraction],
          animations: {
            containerView.alpha = 0.8
          },
          completion: nil
        )
      } else {
        UIView.animate(
          withDuration: 0.08,
          delay: 0.1,
          options: [.beginFromCurrentState, .allowUserInteraction],
          animations: {
            containerView.alpha = 1
          },
          completion: nil
        )
      }
    }

  }

  ///
  ///
  /// - Parameters:
  ///   - cornerRadius:
  ///   - insets:
  ///   - overlayColor:
  /// - Returns:
  public static func shrink(
    cornerRadius: CGFloat,
    insets: UIEdgeInsets,
    overlayColor: UIColor = .init(white: 0, alpha: 0.05)
  ) -> HighlightAnimationDescriptor {

    final class ManualPaddingView: UIView {

      private let content: UIView
      private let padding: UIEdgeInsets

      init(content: UIView, padding: UIEdgeInsets) {
        self.content = content
        self.padding = padding
        super.init(frame: .zero)

        addSubview(content)
      }

      required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }

      override func layoutSubviews() {
        super.layoutSubviews()

        content.frame = bounds.inset(by: padding)

      }
    }

    return .init { context in

      let overlayView = UIView()
      if #available(iOS 13.0, *) {
        overlayView.layer.cornerCurve = .continuous
      } else {
        // Fallback on earlier versions
      }
      overlayView.layer.cornerRadius = cornerRadius

      var insets = insets
      insets.top *= -1
      insets.right *= -1
      insets.bottom *= -1
      insets.left *= -1

      let overlayContainerView = ManualPaddingView(content: overlayView, padding: insets)

      overlayContainerView.alpha = 0
      
      context.setOverlay(overlayContainerView)

      context.setHandler { isHighlighted, _, bodyView in

        overlayView.backgroundColor = overlayColor

        if isHighlighted {
          UIView.animate(
            withDuration: 0.26,
            delay: 0,
            options: [
              .beginFromCurrentState, .allowAnimatedContent,
              .allowUserInteraction, .curveEaseOut,
            ],
            animations: {
              overlayContainerView.layer.opacity = 0.98
              overlayContainerView.transform = .init(scaleX: 0.98, y: 0.98)
              bodyView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            },
            completion: nil
          )

        } else {
          UIView.animate(
            withDuration: 0.20,
            delay: 0,
            options: [
              .beginFromCurrentState, .allowAnimatedContent,
              .allowUserInteraction, .curveEaseOut,
            ],
            animations: {
              overlayContainerView.layer.opacity = 0
              overlayContainerView.transform = .identity
              bodyView.transform = .identity
            },
            completion: nil
          )
        }
      }
      
    }

  }

  ///
  public static func colorOverlay(
    overlayColor: UIColor = .init(white: 0, alpha: 0.05),
    cornerRadius: CGFloat = 0
  ) -> HighlightAnimationDescriptor {

    return .init { context in

      let overlayView = UIView()
      overlayView.backgroundColor = overlayColor
      overlayView.alpha = 0

      overlayView.layer.cornerRadius = cornerRadius
      if #available(iOS 13.0, *) {
        overlayView.layer.cornerCurve = .continuous
      }

      context.setOverlay(overlayView)

      context.setHandler { isHighlighted, _, _ in

        if isHighlighted {
          UIView.animate(
            withDuration: 0.12,
            delay: 0,
            options: [
              .beginFromCurrentState, .curveEaseIn, .allowUserInteraction,
            ],
            animations: {
              overlayView.alpha = 1
            },
            completion: nil
          )

        } else {
          UIView.animate(
            withDuration: 0.08,
            delay: 0.1,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
              overlayView.alpha = 0
            },
            completion: nil
          )
        }
      }

    }

  }
}
