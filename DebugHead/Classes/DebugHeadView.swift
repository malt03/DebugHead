//
//  DebuggerHead.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/27.
//
//

import UIKit
import BugImageCreator

final class DebugHeadView: BugImageView {
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
    UIView.exchangeDidAddSubview()
    
    self.footerView = footerView
    
    if sorting {
      self.menuClasses = menuClasses.sorted { $0.debugMenuDangerLevel.rawValue < $1.debugMenuDangerLevel.rawValue }
    } else {
      self.menuClasses = menuClasses
    }
    
    super.init(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
    
    self.center = center
    let screenSize = UIScreen.main.bounds.size
    ratioCenter = CGPoint(x: center.x / screenSize.width, y: center.y / screenSize.height)
    
    prepareGestureRecognizers()
    prepareDesign()
    prepareNotifications()
    
    if openImmediately {
      DispatchQueue.main.async { [weak self] in
        self?.openDebugMenu()
      }
    }
  }
  
  private func prepareGestureRecognizers() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDebugMenu))
    let forcePressGestureRecognizer = FourcePressGestureRecognizer(target: self, action: #selector(fourcePressed))
    
    addGestureRecognizer(panGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    addGestureRecognizer(forcePressGestureRecognizer)
  }
  
  private func prepareDesign() {
    bugSize = 20
    bugColor = .white
    bugLineWidth = 1
    backgroundColor = .darkGray
    layer.cornerRadius = 4
    layer.masksToBounds = true
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1
  }
  
  private func prepareNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(bringToFront), name: .DebugHeadUIWindowDidAddSubview, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(addSubviewOnKeyWindow), name: .UIWindowDidBecomeKey, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
  }
  
  private static var bundle: Bundle {
    return Bundle(path: Bundle(for: DebugHead.self).path(forResource: "DebugHead", ofType: "bundle")!)!
  }

  private let menuClasses: [DebugMenu.Type]
  private let footerView: UIView?
  private var ratioCenter = CGPoint.zero
  
  private var keyWindow: UIWindow? {
    return UIApplication.shared.keyWindow
  }
  
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
  
  @objc private func openDebugMenu() {
    let nc = UIStoryboard(name: "DebugMenu", bundle: DebugHeadView.bundle).instantiateInitialViewController() as! UINavigationController
    nc.modalPresentationStyle = .overFullScreen
    let vc = nc.topViewController as! DebugMenuTableViewController
    vc.prepare(menuClasses, footerView)
    findTopViewController(keyWindow?.rootViewController)?.present(nc, animated: true, completion: nil)
    UIView.animate(withDuration: 0.3) { self.alpha = 0 }
  }
  
  @objc private func addSubviewOnKeyWindow() {
    removeFromSuperview()
    keyWindow?.addSubview(self)
  }
  
  @objc private func bringToFront() {
    superview?.bringSubview(toFront: self)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    addSubviewOnKeyWindow()
  }
    
  @objc private func orientationDidChange() {
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
