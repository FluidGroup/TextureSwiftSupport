//
//  ShapeDisplaying.swift
//  TextureSwiftSupport
//
//  Created by muukii on 2020/03/28.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

import UIKit

public protocol ShapeDisplaying {
  
  typealias Update = (CGRect) -> UIBezierPath
  
  init(update: @escaping Update)
  
  var shapeFillColor: UIColor? { get set }
  
  var shapeLineWidth: CGFloat { get set }
  
  var shapeStrokeColor: UIColor? { get set }
}
