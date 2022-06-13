import UIKit

extension UIResponder {
  func findNearestViewController() -> UIViewController? {
    sequence(first: self, next: { $0.next })
      .first {
        $0 is UIViewController
      } as? UIViewController
  }
}
