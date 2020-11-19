//
//  DebugMenu.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/28.
//
//

import UIKit

public enum DebugMenuDangerLevel: Int {
  case none
  case low
  case high
  case extreme
}

public protocol DebugMenu {
  var debugMenuTitle: String { get }
  var debugMenuAccessoryType: UITableViewCell.AccessoryType { get }
  var debugMenuDangerLevel: DebugMenuDangerLevel { get }
  func debugMenuSelected(_ debugHead: UIView, tableViewController: UITableViewController, indexPath: IndexPath) -> UIViewController?
}

public struct DebugMenuSection {
    let title: String
    let menus: [DebugMenu]
}
