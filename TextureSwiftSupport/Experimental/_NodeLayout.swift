// Copyright (c) 2019 muukii
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
import AsyncDisplayKit

/// Experimental:
/// This property-wrapper allows to update layout automatically when wrapped-value changed.
@propertyWrapper
public struct _NodeLayout<T> {
  
  public static subscript<EnclosingSelf: ASDisplayNode, TargetValue>(
    _enclosingInstance instance: EnclosingSelf,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, TargetValue>,
    storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
  ) -> T {
    get {
      
      let value = instance[keyPath: storageKeyPath].wrappedValue
      return value
    }
    set {
      instance[keyPath: storageKeyPath].wrappedValue = newValue
      instance.setNeedsLayout()
    }
  }
  
  public var wrappedValue: T
  
  public var projectedValue: _NodeLayout<T> {
    self
  }
  
  public init(wrappedValue: T) {
    self.wrappedValue = wrappedValue
  }
  
}
