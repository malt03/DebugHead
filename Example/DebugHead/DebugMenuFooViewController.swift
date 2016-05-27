//
//  DebugMenuFooViewController.swift
//  DebugHead
//
//  Created by Koji Murata on 2016/05/28.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import DebugHead

class DebugMenuFooViewController: UIViewController, DebugMenu {
  static let debugMenuTitle = "Foo"
  static let debugMenuAccessoryType = UITableViewCellAccessoryType.DisclosureIndicator
  static let debugMenuDangerLevel = DebugMenuDangerLevel.None
  static func debugMenuSelected(debugHead: UIView, debugMenuTableViewController: UITableViewController) -> UIViewController? {
    return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Foo")
  }
}
