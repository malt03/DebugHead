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
  static var debugMenuTitle: String { get }
  static var debugMenuAccessoryType: UITableViewCellAccessoryType { get }
  static var debugMenuDangerLevel: DebugMenuDangerLevel { get }
  static func debugMenuSelected(_ debugHead: UIView, debugMenuTableViewController: UITableViewController) -> UIViewController?
}
