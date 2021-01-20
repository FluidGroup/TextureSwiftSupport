//
//  ViewController.swift
//  SpecBuilder
//
//  Created by Muukii on 06/14/2019.
//  Copyright (c) 2019 Muukii. All rights reserved.
//

import UIKit

import AsyncDisplayKit
import TextureSwiftSupport

final class ViewController: UIViewController {
      
  @IBAction func tapStartButton(_ sender: Any) {
    let controller = MenuViewController()
    
    navigationController?.pushViewController(controller, animated: true)
  }
}
