//
//  ViewController.swift
//  DebugHead
//
//  Created by Koji Murata on 05/27/2016.
//  Copyright (c) 2016 Koji Murata. All rights reserved.
//

import UIKit
import DebugHead

class ViewController: UIViewController, DebugMenu {
  static func debugMenuSelected() -> UIViewController? {
    return UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
  }
  
  static let debugMenuAccessoryType = UITableViewCellAccessoryType.Checkmark
  
  static let debugMenuDangerLevel = DebugMenuDangerLevel.Low
  
  static let debugMenuTitle = "Test"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

