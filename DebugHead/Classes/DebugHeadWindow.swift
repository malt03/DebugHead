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
    
    let key = UIApplication.shared.keyWindow
    makeKeyAndVisible()
    key?.makeKeyAndVisible()

    if openImmediately {
      DispatchQueue.main.async { [weak self] in
        self?.openDebugMenu()
      }
    }
  }
  
  @objc func openDebugMenu() {
    if isOpen { return }
    isOpen = true
    
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
  
  func closeDebugMenu(completion: @escaping () -> Void = {}) {
    if !isOpen {
      completion()
      return
    }
    isOpen = false
    
    gestureRecognizers?.forEach { $0.isEnabled = true }
    
    UIView.animate(withDuration: 0.25, animations: {
      self.frame.size = DebugHeadWindow.size
      self.updateCenter()
      self.rootViewController?.view.frame = CGRect(origin: CGPoint(x: -self.frame.origin.x, y: -self.frame.origin.y), size: UIScreen.main.bounds.size)
      UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
    }, completion: { _ in
      self.rootViewController = UIStoryboard(name: "DebugMenu", bundle: DebugHeadWindow.bundle).instantiateViewController(withIdentifier: "head")
      completion()
    })
    
    lastKeyWindow?.makeKeyAndVisible()
  }
  
  private static var size: CGSize {
    return CGSize(width: 30, height: 30)
  }
  
  private let menuClasses: [DebugMenu.Type]
  private let footerView: UIView?
  private var ratioCenter = CGPoint.zero
  private var lastKeyWindow: UIWindow?
  private(set) var isOpen = false

  private func prepareGestureRecognizers() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDebugMenu))
    let forcePressGestureRecognizer = FourcePressGestureRecognizer(target: self, action: #selector(fourcePressed))
    
    addGestureRecognizer(panGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)
    addGestureRecognizer(forcePressGestureRecognizer)
  }
  
  private static var bundle: Bundle {
    if let path = Bundle(for: DebugHead.self).path(forResource: "DebugHead", ofType: "bundle") {
      return Bundle(path: path)!
    } else {
      return Bundle(for: DebugHead.self)
    }
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
  
  private func updateCenter() {
    let screenSize = UIScreen.main.bounds.size
    center = CGPoint(x: screenSize.width * ratioCenter.x, y: screenSize.height * ratioCenter.y)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
