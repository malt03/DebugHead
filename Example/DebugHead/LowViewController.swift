//
//  LowViewController.swift
//  DebugHead
//
//  Created by Koji Murata on 2016/05/28.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import DebugHead

class LowViewController: UIViewController, DebugMenu {
  static let debugMenuDangerLevel = DebugMenuDangerLevel.Low
  static let debugMenuTitle = "piyo"
  static let debugMenuAccessoryType = UITableViewCellAccessoryType.DetailButton
  static func debugMenuSelected() -> UIViewController? {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Low")
  }
}
