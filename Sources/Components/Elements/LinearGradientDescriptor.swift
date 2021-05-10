
import UIKit

public struct GradientColor: Hashable {
  
  public let color: UIColor
  public let location: CGFloat
  
  public let identifier: String
  
  public init(color: UIColor, location: CGFloat) {
    self.color = color
    self.location = location
    self.identifier = "\(color.description)|\(location.bitPattern.description)"
  }
}

public struct GradientSource: Hashable {
  
  public let colors: [GradientColor]
  public let identifier: String

  public init(colors: [GradientColor]) {
    self.colors = colors
    self.identifier = colors.map { $0.identifier }.joined(separator: ",")
  }
  
}

public struct LinearGradientDescriptor: Equatable {

  // MARK: - Properties
  
  public let source: GradientSource
  public let startPoint: CGPoint
  public let endPoint: CGPoint
  
  public let identifier: String

  // MARK: - Initializers
  
  public init(source: GradientSource, startPoint: CGPoint, endPoint: CGPoint) {
    self.source = source
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.identifier = "\(source.identifier))|\(startPoint.debugDescription)|\(endPoint.debugDescription)"
  }

  public init(locationAndColors: [(CGFloat, UIColor)], startPoint: CGPoint, endPoint: CGPoint) {
    
    self.init(
      source: .init(
        colors: locationAndColors.map { GradientColor(color: $0.1, location: $0.0) }
      ),
      startPoint: startPoint,
      endPoint: endPoint
    )
    
  }

  public func apply(to layer: CAGradientLayer) {

    layer.colors = source.colors.map { $0.color.cgColor }
    layer.locations = source.colors
      .map { $0.location }
      .map(Double.init)
      .map(NSNumber.init(value:))

    layer.startPoint = startPoint
    layer.endPoint = endPoint
  }
  
}
