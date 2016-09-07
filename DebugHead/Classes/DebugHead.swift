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
    footerView fv: UIView? = nil,
    openNow openNow: Bool = false
  ) {
    center = c
    let screenSize = UIScreen.mainScreen().bounds.size
    ratioCenter = CGPoint(x: center.x / screenSize.width, y: center.y / screenSize.height)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    addGestureRecognizer(panGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    
    menuClasses = m
    footerView = fv
    
    if sorting {
      menuClasses.sortInPlace { $0.debugMenuDangerLevel.rawValue < $1.debugMenuDangerLevel.rawValue }
    }
    
    if openNow {
      dispatch_async(dispatch_get_main_queue(), {
        self.openDebugMenu()
      })
    }
  }
  
  init() {
    super.init(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
    bugSize = 20
    bugColor = .whiteColor()
    bugLineWidth = 1
    backgroundColor = .darkGrayColor()
    layer.cornerRadius = 4
    layer.masksToBounds = true
    layer.borderColor = UIColor.whiteColor().CGColor
    layer.borderWidth = 1
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addSubviewOnKeyWindow), name: UIWindowDidBecomeKeyNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(orientationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private static func instance() -> DebugHead {
    return DebugHead()
  }
  
  private static var bundle: NSBundle {
    return NSBundle(path: NSBundle(forClass: DebugHead.self).pathForResource("DebugHead", ofType: "bundle")!)!
  }

  private var menuClasses = [DebugMenu.Type]()
  private var footerView: UIView?
  private var ratioCenter = CGPoint.zero
  
  private var keyWindow: UIWindow? {
    return UIApplication.sharedApplication().keyWindow
  }
  
  @objc private func panned(recognizer: UIPanGestureRecognizer) {
    frame.origin.x += recognizer.translationInView(self).x
    frame.origin.y += recognizer.translationInView(self).y
    recognizer.setTranslation(.zero, inView: self)
    let screenSize = UIScreen.mainScreen().bounds.size
    ratioCenter = CGPoint(x: center.x / screenSize.width, y: center.y / screenSize.height)
  }
  
  @objc private func tapped(recognizer: UITapGestureRecognizer) {
    openDebugMenu()
  }
  
  private func openDebugMenu() {
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
    
  @objc private func orientationDidChange() {
    let screenSize = UIScreen.mainScreen().bounds.size
    center = CGPoint(x: screenSize.width * ratioCenter.x, y: screenSize.height * ratioCenter.y)
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
