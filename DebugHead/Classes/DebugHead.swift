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
    center: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width - 50, y: UIScreen.main.bounds.size.height - 50),
    sorting: Bool = true,
    footerView: UIView? = nil,
    openImmediately: Bool = false
  ) {
    debugHeadView = DebugHeadView(menuClasses: menuClasses, center: center, sorting: sorting, footerView: footerView, openImmediately: openImmediately)
  }
  
  public func remove() {
    debugHeadView?.remove()
    debugHeadView = nil
  }
  
  var debugHeadView: DebugHeadView?
  private init() {}
}
