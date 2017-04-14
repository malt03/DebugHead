//
//  DebugMenuHideDebugHead.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/28.
//
//

open class DebugMenuHideDebugHead: DebugMenu {
  open static let debugMenuTitle = "Hide Debug Head"
  open static let debugMenuDangerLevel = DebugMenuDangerLevel.high
  open static let debugMenuAccessoryType = UITableViewCellAccessoryType.none
  open static func debugMenuSelected(_ debugHead: UIView, debugMenuTableViewController: UITableViewController) -> UIViewController? {
    let alert = UIAlertController(title: "Hide?", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
      DebugHead.shared.remove()
      debugMenuTableViewController.dismiss(animated: true, completion: nil)
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    debugMenuTableViewController.present(alert, animated: true, completion: nil)
    return nil
  }
}
