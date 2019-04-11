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
    openImmediately: Bool,
    sideStickInfo: SideStickInfo?
  ){
    self.footerView = footerView
    self.sideStickInfo = sideStickInfo
    
    if sorting {
      self.menuClasses = menuClasses.sorted { $0.debugMenuDangerLevel.rawValue < $1.debugMenuDangerLevel.rawValue }
    } else {
      self.menuClasses = menuClasses
    }
    
    super.init(frame: CGRect(origin: .zero, size: DebugHeadWindow.size))
    
    rootViewController = UIStoryboard(name: "DebugMenu", bundle: DebugHeadWindow.bundle).instantiateViewController(withIdentifier: "head")
    windowLevel = UIWindow.Level.statusBar - 1
    
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
  private let sideStickInfo: SideStickInfo?

  private func prepareGestureRecognizers() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDebugMenu))
    addGestureRecognizer(panGestureRecognizer)
    addGestureRecognizer(tapGestureRecognizer)

    // The force press gesture is recognized as normal tap gesture in simulator when 'UseTrack Force' is enable.
    // So we disable to the force press gesture in the simulator.
    //   Simulator's setting: Hardware -> Touch Pressure -> UseTrack Force ✔︎
    #if targetEnvironment(simulator)
    #else
    let forcePressGestureRecognizer = FourcePressGestureRecognizer(target: self, action: #selector(forcePressed))
    addGestureRecognizer(forcePressGestureRecognizer)
    #endif
  }
  
  private static var bundle: Bundle {
    if let path = Bundle(for: DebugHead.self).path(forResource: "DebugHead", ofType: "bundle") {
      return Bundle(path: path)!
    } else {
      return Bundle(for: DebugHead.self)
    }
  }
  
  @objc private func panned(_ gestureRecognizer: UIPanGestureRecognizer) {
    guard let gesturingView = gestureRecognizer.view else { return }
    
    let view = self
    switch gestureRecognizer.state {
    case .began:
      break
    case .changed:
      let point  = gestureRecognizer.translation(in: view)
      let center = CGPoint(
        x: gesturingView.center.x + point.x,
        y: gesturingView.center.y + point.y
      )
      gesturingView.center = center
      gestureRecognizer.setTranslation(.zero, in: view)
    default:
      guard let sideStickInfo = sideStickInfo else { return }
      let safeAreaInset = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
      let mergin = sideStickInfo.mergin
      let outlineRect = CGRect(
        x: safeAreaInset.left + mergin + DebugHeadWindow.size.width / 2,
        y: safeAreaInset.top + mergin + DebugHeadWindow.size.height / 2,
        width: UIScreen.main.bounds.width - safeAreaInset.left - safeAreaInset.right - mergin * 2 - DebugHeadWindow.size.width,
        height: UIScreen.main.bounds.height - safeAreaInset.top - safeAreaInset.bottom - mergin * 2 - DebugHeadWindow.size.height
      )
      
      let initialVelocity = gestureRecognizer.velocity(in: self)
      if initialVelocity.length <= 200 || !outlineRect.contains(center) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
          self.center = outlineRect.nearSidePoint(for: self.center)
          let screenSize = UIScreen.main.bounds.size
          self.ratioCenter = CGPoint(x: self.center.x / screenSize.width, y: self.center.y / screenSize.height)
        }, completion: nil)
        return
      }

      let intersection = outlineRect.intersection(from: center, velocity: initialVelocity)
      UIView.animate(
        withDuration: 0.2,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: initialVelocity.length / center.distance(to: intersection),
        options: [],
        animations: {
          self.center = intersection
          let screenSize = UIScreen.main.bounds.size
          self.ratioCenter = CGPoint(x: self.center.x / screenSize.width, y: self.center.y / screenSize.height)
        },
        completion: nil
      )
    }
  }

  #if targetEnvironment(simulator)
  #else
  @objc private func forcePressed() {
    DebugHead.shared.remove()
  }
  #endif

  private func updateCenter() {
    let screenSize = UIScreen.main.bounds.size
    center = CGPoint(x: screenSize.width * ratioCenter.x, y: screenSize.height * ratioCenter.y)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
