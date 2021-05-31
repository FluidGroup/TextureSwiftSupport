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

import UIKit

public struct HapticsDescriptor {

  public enum Event: Equatable {
    case onTouchDownInside
    case onTouchUpInside
    case onLongPress
  }

  private let _onReceiveEvent: (Event) -> Void

  public init(
    onReceiveEvent: @escaping (Event) -> Void
  ) {
    self._onReceiveEvent = onReceiveEvent
  }

  public func send(event: Event) {
    _onReceiveEvent(event)
  }
}

extension HapticsDescriptor {

  public static func impactOnTouchUpInside(
    style: UIImpactFeedbackGenerator.FeedbackStyle = .light,
    delay: DispatchTimeInterval = .seconds(0)
  ) -> Self {

    let feedbackGenerator = UIImpactFeedbackGenerator(style: style)

    return self.init { event in
      if case .onTouchUpInside = event {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
          feedbackGenerator.impactOccurred()
        }
      }
    }
  }

}
