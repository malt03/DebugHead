//
//  DebugMenuExit.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/28.
//
//

open class DebugMenuExit: DebugMenu {
  public static let debugMenuTitle = "Exit"
  public static let debugMenuDangerLevel = DebugMenuDangerLevel.extreme
  public static let debugMenuAccessoryType = UITableViewCell.AccessoryType.none
  public static func debugMenuSelected(_ debugHead: UIView, tableViewController: UITableViewController, indexPath: IndexPath) -> UIViewController? {
    let alert = UIAlertController(title: "Exit", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
      exit(1)
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    tableViewController.present(alert, animated: true, completion: nil)
    return nil
  }
}
