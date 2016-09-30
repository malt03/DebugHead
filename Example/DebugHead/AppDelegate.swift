//
//  AppDelegate.swift
//  DebugHead
//
//  Created by Koji Murata on 05/27/2016.
//  Copyright (c) 2016 Koji Murata. All rights reserved.
//

import UIKit
import DebugHead

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func applicationDidFinishLaunching(_ application: UIApplication) {
    DebugHead.shared.prepare(menuClasses: [DebugMenuExit.self, DebugMenuHideDebugHead.self, DebugMenuFooViewController.self])
  }
}

