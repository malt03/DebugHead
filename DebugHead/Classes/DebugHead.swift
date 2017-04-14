//
//  DebugHead.swift
//  Pods
//
//  Created by Koji Murata on 2017/04/14.
//
//

import Foundation

final public class DebugHead {
  public static var shared: DebugHead! = DebugHead()
  
  public func prepare(
    menuClasses: [DebugMenu.Type],
    center: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width - 50, y: UIScreen.main.bounds.size.height - 50),
    sorting: Bool = true,
    footerView: UIView? = nil,
    openImmediately: Bool = false
  ) {
    let useMenuClasses: [DebugMenu.Type]
    if sorting {
      useMenuClasses = menuClasses.sorted { $0.debugMenuDangerLevel.rawValue < $1.debugMenuDangerLevel.rawValue }
    } else {
      useMenuClasses = menuClasses
    }
    
    let debugHeadViewController = UIStoryboard(name: "DebugHead", bundle: DebugHead.bundle).instantiateInitialViewController() as! DebugHeadViewController
    debugHeadViewController.prepare(center: center, menuClasses: useMenuClasses, footerView: footerView) { [weak self] in
      self?.window.isHidden = true
      DebugHead.shared = nil
    }
    window.rootViewController = debugHeadViewController
    window.isHidden = false
  }
  
  static var bundle: Bundle {
    return Bundle(path: Bundle(for: DebugHead.self).path(forResource: "DebugHead", ofType: "bundle")!)!
  }
  
  private let window = TouchableOnlyChildWindow(frame: UIScreen.main.bounds)
  private init() {
    window.backgroundColor = .clear
    window.windowLevel = UIWindowLevelNormal + 1
  }
}
