//
//  DebuggerHead.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/27.
//
//

import UIKit
import BugImageCreator

public class DebugHead: BugImageView {
  public static let sharedInstance = DebugHead.instance()

  public func prepare(
    menuClasses m: [DebugMenu.Type],
    center c: CGPoint = CGPoint(x: UIScreen.mainScreen().bounds.size.width - 50, y: UIScreen.mainScreen().bounds.size.height - 50),
    sorting: Bool = true,
    footerView fv: UIView? = nil
  ) {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addSubviewOnKeyWindow), name: UIWindowDidBecomeKeyNotification, object: nil)
    
    center = c
    layer.borderColor = UIColor.whiteColor().CGColor
    layer.borderWidth = 1
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    addGestureRecognizer(panGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    
    menuClasses = m
    footerView = fv
    
    if sorting {
      menuClasses.sortInPlace { $0.debugMenuDangerLevel.rawValue < $1.debugMenuDangerLevel.rawValue }
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    bugSize = 20
    bugColor = .whiteColor()
    bugLineWidth = 1
  }
  
  private static func instance() -> DebugHead {
    return UINib(nibName: "DebugHead", bundle: bundle).instantiateWithOwner(self, options: nil).first as! DebugHead
  }
  
  private static var bundle: NSBundle {
    return NSBundle(path: NSBundle(forClass: DebugHead.self).pathForResource("DebugHead", ofType: "bundle")!)!
  }

  private var menuClasses = [DebugMenu.Type]()
  private var footerView: UIView?
  
  private var keyWindow: UIWindow? {
    return UIApplication.sharedApplication().keyWindow
  }
  
  @objc private func panned(recognizer: UIPanGestureRecognizer) {
    frame.origin.x += recognizer.translationInView(self).x
    frame.origin.y += recognizer.translationInView(self).y
    recognizer.setTranslation(.zero, inView: self)
  }
  
  @objc private func tapped(recognizer: UITapGestureRecognizer) {
    let nc = UIStoryboard(name: "DebugMenu", bundle: DebugHead.bundle).instantiateInitialViewController() as! UINavigationController
    let vc = nc.topViewController as! DebugMenuTableViewController
    vc.prepare(menuClasses, footerView)
    findTopViewController(keyWindow?.rootViewController)?.presentViewController(nc, animated: true, completion: nil)
    UIView.animateWithDuration(0.3) { self.alpha = 0 }
  }
  
  @objc private func addSubviewOnKeyWindow() {
    removeFromSuperview()
    keyWindow?.addSubview(self)
  }
  
  private func findTopViewController(controller: UIViewController?) -> UIViewController? {
    guard let c = controller else { return nil }
    
    switch c {
    case is UIAlertController:
      return nil
    case let c as UITabBarController:
      return findTopViewController(c.selectedViewController) ?? c
    case let c as UINavigationController:
      return findTopViewController(c.visibleViewController) ?? c
    default:
      if let presentedViewController = c.presentedViewController {
        return findTopViewController(presentedViewController) ?? c
      }
      return c
    }
  }
}
