
import Foundation
import AsyncDisplayKit

fileprivate var _storageKey: Void?

extension ASDisplayNode {

  private var storage: NSMapTable<NSString, ASDisplayNode> {

    if let associated = objc_getAssociatedObject(self, &_storageKey) as? NSMapTable<NSString, ASDisplayNode> {
      return associated
    } else {
      let associated = NSMapTable<NSString, ASDisplayNode>.strongToWeakObjects()
      objc_setAssociatedObject(self, &_storageKey, associated, .OBJC_ASSOCIATION_RETAIN)
      return associated
    }
  }

  /**
   [Still experimental]
   Creates an instance of node at once, and it will be associated with the receiver node.
   It requires to enable `automaticallyManagesSubnodes`.
   */
  public func _makeNode(
    file: StaticString = #file,
    line: UInt = #line,
    column: UInt = #column,
    _ make: () -> ASDisplayNode
  ) -> ASDisplayNode {

    assert(automaticallyManagesSubnodes, "Use _makeNode, must to use `automaticallyManagesSubnodes`.")

    let key = "\(file),\(line),\(column)" as NSString

    if let node = storage.object(forKey: key) {
      return node
    } else {
      let newNode = make()
      storage.setObject(newNode, forKey: key)
      return newNode
    }

  }

}
