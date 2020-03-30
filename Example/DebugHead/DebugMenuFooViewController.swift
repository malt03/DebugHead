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
  let debugMenuTitle = "Foo"
  let debugMenuAccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
  let debugMenuDangerLevel = DebugMenuDangerLevel.none
  func debugMenuSelected(_ debugHead: UIView, tableViewController: UITableViewController, indexPath: IndexPath) -> UIViewController? {
    return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Foo")
  }
}
