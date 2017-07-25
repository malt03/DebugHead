//
//  DebuggerHead.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/27.
//
//

import UIKit
import BugImageCreator

final class DebugHeadWindow: UIWindow {
  func remove() {
    NotificationCenter.default.removeObserver(self)
    removeFromSuperview()
  }
  
  init(
    menuClasses: [DebugMenu.Type],
    center: CGPoint,
    sorting: Bool,
    footerView: UIView?,
    openImmediately: Bool
  ){
    self.footerView = footerView
    
    if sorting {
      self.menuClasses = menuClasses.sorted { $0.debugMenuDangerLevel.rawValue < $1.debugMenuDangerLevel.rawValue }
    } else {
      self.menuClasses = menuClasses
    }
    
    super.init(frame: CGRect(origin: .zero, size: DebugHeadWindow.size))
    
    rootViewController = UIStoryboard(name: "DebugMenu", bundle: DebugHeadWindow.bundle).instantiateViewController(withIdentifier: "head")
    windowLevel = UIWindowLevelStatusBar - 1
    
    self.center = center
    let screenSize = UIScreen.main.bounds.size
    ratioCenter = CGPoint(x: center.x / screenSize.width, y: center.y / screenSize.height)
    layer.masksToBounds = true

    prepareGestureRecognizers()
    prepareNotifications()
    
    if openImmediately {
      DispatchQueue.main.async { [weak self] in
        self?.openDebugMenu()
      }
    }
    
    let key = UIApplication.shared.keyWindow
    makeKeyAndVisible()
    key?.makeKeyAndVisible()
  }
  
  private static var size: CGSize {
    return CGSize(width: 30, height: 30)
  }
  
  private func prepareGestureRecognizers() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDebugMenu))
    let forcePressGestureRecognizer = FourcePressGestureRecognizer(target: self, action: #selector(fourcePressed))
    
    addGestureRecognizer(panGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    addGestureRecognizer(forcePressGestureRecognizer)
  }
  
  private func prepareNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
  }
  
  private static var bundle: Bundle {
    return Bundle(path: Bundle(for: DebugHead.self).path(forResource: "DebugHead", ofType: "bundle")!)!
  }

  private let menuClasses: [DebugMenu.Type]
  private let footerView: UIView?
  private var ratioCenter = CGPoint.zero
  
  @objc private func panned(_ recognizer: UIPanGestureRecognizer) {
    frame.origin.x += recognizer.translation(in: self).x
    frame.origin.y += recognizer.translation(in: self).y
    recognizer.setTranslation(.zero, in: self)
    let screenSize = UIScreen.main.bounds.size
    ratioCenter = CGPoint(x: center.x / screenSize.width, y: center.y / screenSize.height)
  }
  
  @objc private func fourcePressed() {
    DebugHead.shared.remove()
  }
  
  private var lastKeyWindow: UIWindow?
  
  func openDebugMenu() {
    gestureRecognizers?.forEach { $0.isEnabled = false }
    
    let nc = UIStoryboard(name: "DebugMenu", bundle: DebugHeadWindow.bundle).instantiateInitialViewController() as! UINavigationController
    let vc = nc.topViewController as! DebugMenuTableViewController
    vc.prepare(self.menuClasses, self.footerView)
    rootViewController = nc
    
    nc.view.frame = CGRect(origin: CGPoint(x: -frame.origin.x, y: -frame.origin.y), size: UIScreen.main.bounds.size)
    
    UIView.animate(withDuration: 0.25) {
      self.frame = UIScreen.main.bounds
      nc.view.frame = UIScreen.main.bounds
      UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
    }
    
    lastKeyWindow = UIApplication.shared.keyWindow
    makeKeyAndVisible()
  }
  
  func closeDebugMenu() {
    gestureRecognizers?.forEach { $0.isEnabled = true }
    
    UIView.animate(withDuration: 0.25, animations: {
      self.frame.size = DebugHeadWindow.size
      self.updateCenter()
      self.rootViewController?.view.frame = CGRect(origin: CGPoint(x: -self.frame.origin.x, y: -self.frame.origin.y), size: UIScreen.main.bounds.size)
      UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
    }, completion: { _ in
      self.rootViewController = UIStoryboard(name: "DebugMenu", bundle: DebugHeadWindow.bundle).instantiateViewController(withIdentifier: "head")
    })
    
    lastKeyWindow?.makeKeyAndVisible()
  }
  
  @objc private func bringToFront() {
    superview?.bringSubview(toFront: self)
  }
  
  @objc private func orientationDidChange() {
    updateCenter()
  }
  
  private func updateCenter() {
    let screenSize = UIScreen.main.bounds.size
    center = CGPoint(x: screenSize.width * ratioCenter.x, y: screenSize.height * ratioCenter.y)
  }
  
  private func findTopViewController(_ controller: UIViewController?) -> UIViewController? {
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
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
