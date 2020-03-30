//
//  DebugMenuHideDebugHead.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/28.
//
//

open class DebugMenuHideDebugHead: DebugMenu {
  public let debugMenuTitle = "Hide Debug Head"
  public let debugMenuDangerLevel = DebugMenuDangerLevel.high
  public let debugMenuAccessoryType = UITableViewCell.AccessoryType.none
  public func debugMenuSelected(_ debugHead: UIView, tableViewController: UITableViewController, indexPath: IndexPath) -> UIViewController? {
    let alert = UIAlertController(title: "Hide?", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
      DebugHead.shared.remove()
      tableViewController.dismiss(animated: true, completion: nil)
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    tableViewController.present(alert, animated: true, completion: nil)
    return nil
  }

  public init() {}
}
