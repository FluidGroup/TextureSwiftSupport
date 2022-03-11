//

import Foundation
import AsyncDisplayKit
import Descriptors

/**
 A display node that displays the gradient with CoreGraphics based drawing.
 Compared with GradientLayerNode, the gradient would be more smooth.
 */
open class GradientDrawingNode: NamedDisplayNodeBase {

  public override var supportsLayerBacking: Bool {
    true
  }

  private var drawer: LinearGradientDrawer?

  public override init() {
    super.init()
    isOpaque = false
  }

  public convenience init(descriptor: LinearGradientDescriptor) {
    self.init()
    self.drawer = LinearGradientDrawer(descriptor: descriptor)
  }

  public func setDescriptor(descriptor: LinearGradientDescriptor) {
    lock(); defer { unlock() }
    self.drawer = LinearGradientDrawer(descriptor: descriptor)
    setNeedsDisplay()
  }

  public override func drawParameters(forAsyncLayer layer: _ASDisplayLayer) -> NSObjectProtocol? {
    lock(); defer { unlock() }
    return ["drawer" : drawer as Any] as NSDictionary
  }

  public override class func draw(_ bounds: CGRect, withParameters parameters: Any?, isCancelled isCancelledBlock: () -> Bool, isRasterizing: Bool) {

    guard let dic = parameters as? NSDictionary else {
      return
    }

    guard let drawer = dic["drawer"] as? LinearGradientDrawer else {
      return
    }

    let context = UIGraphicsGetCurrentContext()!
    drawer.draw(in: context, rect: bounds)

  }

}
