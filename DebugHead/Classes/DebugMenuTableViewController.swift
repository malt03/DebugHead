//
//  DebugMenuTableViewController.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/27.
//
//

import UIKit

class DebugMenuTableViewController: UITableViewController {
  @IBAction func close() {
    dismissViewControllerAnimated(true, completion: nil)
    UIView.animateWithDuration(0.3) { DebugHead.sharedInstance.alpha = 1 }
  }
  
  func prepare(m: [DebugMenu.Type], _ fv: UIView?) {
    menuClasses = m
    footerView = fv
  }
  private var menuClasses = [DebugMenu.Type]()
  private var footerView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.barTintColor = .darkGrayColor()
    navigationController?.navigationBar.tintColor = .whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuClasses.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("default", forIndexPath: indexPath)
    let menuClass = menuClasses[indexPath.row]
    cell.textLabel?.textColor = UIColor.fromDangerLevel(menuClass.debugMenuDangerLevel)
    cell.textLabel?.text = menuClass.debugMenuTitle
    cell.accessoryType = menuClass.debugMenuAccessoryType
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    guard let vc = menuClasses[indexPath.row].debugMenuSelected(DebugHead.sharedInstance, debugMenuTableViewController: self) else {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      return
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return footerView?.frame.height ?? 0
  }
  
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return footerView
  }
}

extension UIColor {
  static func fromDangerLevel(level: DebugMenuDangerLevel) -> UIColor {
    switch level {
    case .None:     return .blackColor()
    case .Low:      return UIColor(red: 0, green: 0.3843, blue: 0.1451, alpha: 1)
    case .High:     return UIColor(red: 0.9961, green: 0.8078, blue: 0, alpha: 1)
    case .Extreme:  return UIColor(red: 0.7490, green: 0.1922, blue: 0.1059, alpha: 1)
    }
  }
}
