//
//  DebugHeadViewController.swift
//  Pods
//
//  Created by Koji Murata on 2017/04/14.
//
//

import UIKit
import BugImageCreator

final class DebugHeadViewController: UIViewController {
  private var menuClasses: [DebugMenu.Type]!
  private var footerView: UIView?
  
  @IBOutlet private weak var debugHeadView: DebugHeadView!
  
  private var initialCenter: CGPoint!
  private var forcePressedHandler: (() -> Void)!
  
  func prepare(center: CGPoint, menuClasses: [DebugMenu.Type], footerView: UIView?, forcePressedHandler: @escaping (() -> Void)) {
    self.menuClasses = menuClasses
    self.footerView = footerView
    self.forcePressedHandler = forcePressedHandler
    initialCenter = center
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    debugHeadView.center = initialCenter
  }
  
  @IBAction private func tappedHead() {
    performSegue(withIdentifier: "open", sender: nil)
  }
  
  @IBAction private func pannedHead(_ sender: PanGestureRecognizer) {
    debugHeadView.frame.origin.x += sender.translation.dx
    debugHeadView.frame.origin.y += sender.translation.dy
  }
  
  @IBAction private func forcePressedHead() {
    forcePressedHandler()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let nc = segue.destination as? UINavigationController,
      let vc = nc.topViewController as? DebugMenuTableViewController {
      vc.prepare(menuClasses, footerView)
    }
  }
}
