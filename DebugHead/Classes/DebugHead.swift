//
//  DebugHead.swift
//  Pods
//
//  Created by Koji Murata on 2017/04/15.
//
//

import Foundation

public final class DebugHead {
  public static let shared = DebugHead()
  
  public func prepare(
    menuClasses: [DebugMenu.Type],
    center: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width - 50, y: UIScreen.main.bounds.size.height - 100),
    sorting: Bool = true,
    footerView: UIView? = nil,
    openImmediately: Bool = false,
    sideStickInfo: SideStickInfo? = .default
  ) {
    debugHeadWindow = DebugHeadWindow(
      menuClasses: menuClasses,
      center: center,
      sorting: sorting,
      footerView: footerView,
      openImmediately: openImmediately,
      sideStickInfo: sideStickInfo
    )
    NotificationCenter.default.addObserver(self, selector: #selector(windowDidBecomeKey), name: UIWindow.didBecomeKeyNotification, object: nil)
  }
  
  @objc private func windowDidBecomeKey() {
    guard let debugHeadWindow = debugHeadWindow else { return }
    if UIApplication.shared.keyWindow == debugHeadWindow && !debugHeadWindow.isOpen {
      var next = false
      for window in UIApplication.shared.windows.reversed() {
        if next {
          window.makeKeyAndVisible()
          return
        }
        if window == debugHeadWindow { next = true }
      }
    }
  }
  
  public func remove() {
    debugHeadWindow?.closeDebugMenu {
      self.debugHeadWindow = nil
    }
  }
  
  public func open() {
    debugHeadWindow?.openDebugMenu()
  }
  
  public func close() {
    debugHeadWindow?.closeDebugMenu()
  }
  
  var debugHeadWindow: DebugHeadWindow?
  private init() {}
}
