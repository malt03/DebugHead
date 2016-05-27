//
//  DebugMenuExit.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/28.
//
//

public class DebugMenuExit: DebugMenu {
  public static let debugMenuTitle = "Exit"
  public static let debugMenuDangerLevel = DebugMenuDangerLevel.Extreme
  public static let debugMenuAccessoryType = UITableViewCellAccessoryType.None
  public static func debugMenuSelected(debugMenuTableViewController: UITableViewController) -> UIViewController? {
    let alert = UIAlertController(title: "Exit", message: nil, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Destructive) { _ in
      exit(1)
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    debugMenuTableViewController.presentViewController(alert, animated: true, completion: nil)
    return nil
  }
}