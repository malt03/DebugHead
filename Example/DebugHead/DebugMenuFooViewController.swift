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
  static let debugMenuAccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
  static let debugMenuDangerLevel = DebugMenuDangerLevel.none
  static func debugMenuSelected(_ debugHead: UIView, debugMenuTableViewController: UITableViewController) -> UIViewController? {
    return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Foo")
  }
}
