//
//  DebugMenuHideDebugHead.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/28.
//
//

public class DebugMenuHideDebugHead: DebugMenu {
  public static let debugMenuTitle = "Hide Debug Head"
  public static let debugMenuDangerLevel = DebugMenuDangerLevel.High
  public static let debugMenuAccessoryType = UITableViewCellAccessoryType.None
  public static func debugMenuSelected(debugHead: UIView, debugMenuTableViewController: UITableViewController) -> UIViewController? {
    let alert = UIAlertController(title: "Exit", message: nil, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Destructive) { _ in
      debugHead.hidden = true
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    debugMenuTableViewController.presentViewController(alert, animated: true, completion: nil)
    return nil
  }
}
