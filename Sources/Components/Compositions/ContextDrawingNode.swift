
import Foundation

import AsyncDisplayKit

public final class ContextDrawingNode: ASDisplayNode {
  private let drawingInstructions: (CGContext, CGRect) -> Void

  required public init (_ drawingInstructions: @escaping (CGContext, CGRect) -> Void) {
    self.drawingInstructions = drawingInstructions
    super.init()
  }

  public override func drawParameters(forAsyncLayer layer: _ASDisplayLayer) -> NSObjectProtocol? {
    return ["drawingInstructions" : drawingInstructions] as NSDictionary
  }


  public override class func draw(_ bounds: CGRect, withParameters parameters: Any?, isCancelled isCancelledBlock: () -> Bool, isRasterizing: Bool) {
    guard
      let context = UIGraphicsGetCurrentContext(),
      let dictionnary = parameters as? NSDictionary,
      let instructions = dictionnary["drawingInstructions"] as? (CGContext, CGRect) -> Void
    else { return }
    instructions(context, bounds)
  }
}
