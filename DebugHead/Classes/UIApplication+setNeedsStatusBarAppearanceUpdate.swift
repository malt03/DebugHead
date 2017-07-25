//
//  UIApplication+setNeedsStatusBarAppearanceUpdate.swift
//  Pods
//
//  Created by Koji Murata on 2017/07/25.
//
//

import UIKit

extension UIApplication {
  func setNeedsStatusBarAppearanceUpdate() {
    windows.forEach { $0.rootViewController?.setNeedsStatusBarAppearanceUpdate() }
  }
}
