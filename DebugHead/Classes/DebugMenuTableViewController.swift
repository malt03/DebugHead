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
    dismiss(animated: true, completion: nil)
    UIView.animate(withDuration: 0.3) { DebugHead.sharedInstance.alpha = 1 }
  }
  
  func prepare(_ m: [DebugMenu.Type], _ fv: UIView?) {
    menuClasses = m
    footerView = fv
  }
  fileprivate var menuClasses = [DebugMenu.Type]()
  fileprivate var footerView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.barTintColor = .darkGray
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.white
    ]
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuClasses.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
    let menuClass = menuClasses[(indexPath as NSIndexPath).row]
    cell.textLabel?.textColor = UIColor.fromDangerLevel(menuClass.debugMenuDangerLevel)
    cell.textLabel?.text = menuClass.debugMenuTitle
    cell.accessoryType = menuClass.debugMenuAccessoryType
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let vc = menuClasses[(indexPath as NSIndexPath).row].debugMenuSelected(DebugHead.sharedInstance, debugMenuTableViewController: self) else {
      tableView.deselectRow(at: indexPath, animated: true)
      return
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return footerView?.frame.height ?? 0
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return footerView
  }
}

extension UIColor {
  static func fromDangerLevel(_ level: DebugMenuDangerLevel) -> UIColor {
    switch level {
    case .none:     return .black
    case .low:      return UIColor(red: 0, green: 0.3843, blue: 0.1451, alpha: 1)
    case .high:     return UIColor(red: 0.9961, green: 0.8078, blue: 0, alpha: 1)
    case .extreme:  return UIColor(red: 0.7490, green: 0.1922, blue: 0.1059, alpha: 1)
    }
  }
}
