//
//  DebugMenuExit.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/28.
//
//

open class DebugMenuExit: DebugMenu {
  open static let debugMenuTitle = "Exit"
  open static let debugMenuDangerLevel = DebugMenuDangerLevel.extreme
  open static let debugMenuAccessoryType = UITableViewCellAccessoryType.none
  open static func debugMenuSelected(_ debugHead: UIView, debugMenuTableViewController: UITableViewController) -> UIViewController? {
    let alert = UIAlertController(title: "Exit", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
      exit(1)
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    debugMenuTableViewController.present(alert, animated: true, completion: nil)
    return nil
  }
}
