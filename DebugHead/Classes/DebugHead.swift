//
//  DebuggerHead.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/27.
//
//

import UIKit
import BugImageCreator

open class DebugHead: BugImageView {
  open static let shared = DebugHead.instance()

  open func prepare(
    menuClasses m: [DebugMenu.Type],
    center c: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width - 50, y: UIScreen.main.bounds.size.height - 50),
    sorting: Bool = true,
    footerView fv: UIView? = nil,
    openImmediately: Bool = false
  ) {
    center = c
    let screenSize = UIScreen.main.bounds.size
    ratioCenter = CGPoint(x: center.x / screenSize.width, y: center.y / screenSize.height)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    addGestureRecognizer(panGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    
    menuClasses = m
    footerView = fv
    
    if sorting {
      menuClasses.sort { $0.debugMenuDangerLevel.rawValue < $1.debugMenuDangerLevel.rawValue }
    }
    
    if openImmediately {
      DispatchQueue.main.async { [weak self] in
        self?.openDebugMenu()
      }
    }
  }
  
  init() {
    super.init(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
    bugSize = 20
    bugColor = .white
    bugLineWidth = 1
    backgroundColor = .darkGray
    layer.cornerRadius = 4
    layer.masksToBounds = true
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1
    NotificationCenter.default.addObserver(self, selector: #selector(addSubviewOnKeyWindow), name: NSNotification.Name.UIWindowDidBecomeKey, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private static func instance() -> DebugHead {
    return DebugHead()
  }
  
  private static var bundle: Bundle {
    return Bundle(path: Bundle(for: DebugHead.self).path(forResource: "DebugHead", ofType: "bundle")!)!
  }

  private var menuClasses = [DebugMenu.Type]()
  private var footerView: UIView?
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
  
  @objc private func tapped(_ recognizer: UITapGestureRecognizer) {
    openDebugMenu()
  }
  
  private func openDebugMenu() {
    let nc = UIStoryboard(name: "DebugMenu", bundle: DebugHead.bundle).instantiateInitialViewController() as! UINavigationController
    let vc = nc.topViewController as! DebugMenuTableViewController
    vc.prepare(menuClasses, footerView)
    findTopViewController(keyWindow?.rootViewController)?.present(nc, animated: true, completion: nil)
    UIView.animate(withDuration: 0.3) { self.alpha = 0 }
  }
  
  @objc private func addSubviewOnKeyWindow() {
    removeFromSuperview()
    keyWindow?.addSubview(self)
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
}
