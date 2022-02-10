
import Darwin
import Foundation
import AsyncDisplayKit
import ObjectiveC

extension ASDisplayNode {

  @objc
  fileprivate dynamic func textureSwiftSupport_ASDisplayNode_init() -> ASDisplayNode {
    TextureDebug.assertNotInLayoutSpecThatFits(
      "Attempted to initialize an instance of \"\(String(describing: Self.self))\" inside \"\(#selector(ASDisplayNode.layoutSpecThatFits(_:)))\""
    )
    return self.textureSwiftSupport_ASDisplayNode_init()
  }
}

public enum TextureDebug {

  public static func initialize() {

    _ = self.isInitialized
  }

  private static let isInitialized: Void = {

      let originalSelector = #selector(NSObject.init)
      let swizzledSelector = #selector(ASDisplayNode.textureSwiftSupport_ASDisplayNode_init)
      guard
        let originalMethod = class_getInstanceMethod(ASDisplayNode.self, originalSelector),
        let swizzledMethod = class_getInstanceMethod(ASDisplayNode.self, swizzledSelector)
      else {
        return
      }
      method_exchangeImplementations(originalMethod, swizzledMethod)
  }()

  static func assertNotInLayoutSpecThatFits(_ message: String) {
    assert(
      { () -> Bool in
        let columnSeparators: CharacterSet = .init(charactersIn: " -[]+?.,")
        for row in Thread.callStackSymbols {

          let columns = row
            .components(separatedBy: columnSeparators)
            .filter({ !$0.isEmpty })
          guard
            columns.count > 4,
            let demangledFunction = self.demangle(columns[4]),
            demangledFunction.hasSuffix(".layoutSpecThatFits(__C.ASSizeRange) -> __C.ASLayoutSpec")
          else {
            continue
          }
          return false
        }
        return true
      }(),
      message
    )
  }

  private static func demangle(_ string: String) -> String? {
    enum Static {
      static let demangler: Demangler = .init()
    }
    return Static.demangler.demangle(string)
  }

  private final class Demangler {

    // https://github.com/apple/swift/blob/e6a1e23a9f29b07b0f395ca3e0e137dc67f458e5/stdlib/public/runtime/Demangle.cpp
    typealias Swift_Demangle = @convention(c) (
      _ mangledName: UnsafePointer<UInt8>?,
      _ mangledNameLength: Int,
      _ outputBuffer: UnsafeMutablePointer<UInt8>?,
      _ outputBufferSize: UnsafeMutablePointer<Int>?,
      _ flags: UInt32
    ) -> UnsafeMutablePointer<Int8>?

    let rawDemangle: Swift_Demangle

    init() {
      guard let sym = dlsym(dlopen(nil, RTLD_NOW), "swift_demangle") else {
        self.rawDemangle = { (_, _, _, _, _) in nil }
        return
      }
      self.rawDemangle = unsafeBitCast(sym, to: Swift_Demangle.self)
    }
    
    func demangle(_ string: String) -> String? {
      guard let cString = self.rawDemangle(string, string.count, nil, nil, 0) else {
        return nil
      }
      defer { cString.deallocate() }
      return String(cString: cString)
    }
  }
}
