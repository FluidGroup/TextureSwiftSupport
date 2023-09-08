import UIKit

final class ZStackView: UIView {

  init(views: [UIView]) {
    super.init(frame: .zero)

    views.forEach { view in
      addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        view.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor),
        view.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
        view.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor),
        view.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),

        {
          let c = view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
          c.priority = .defaultLow
          return c
        }(),
        {
          let c = view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
          c.priority = .defaultLow
          return c
        }(),
      ])
    }

    setContentHuggingPriority(.defaultHigh, for: .horizontal)
    setContentHuggingPriority(.defaultHigh, for: .vertical)

  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }

}

