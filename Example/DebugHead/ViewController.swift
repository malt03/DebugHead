//
//  ViewController.swift
//  DebugHead
//
//  Created by Koji Murata on 05/27/2016.
//  Copyright (c) 2016 Koji Murata. All rights reserved.
//

import UIKit
import DebugHead

class ViewController: UIViewController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  private static var window: UIWindow?
  private static var count = 0
  
  @IBOutlet weak var countLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    countLabel.text = "\(ViewController.count)"
    ViewController.count += 1
  }
  
  @IBAction func open() {
    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
//    let w = UIWindow(frame: UIScreen.main.bounds)
//    w.windowLevel = UIWindowLevelNormal
//    w.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
//    w.makeKeyAndVisible()
//    ViewController.window = w
  }
  
  @IBAction func close() {
    ViewController.window = nil
  }
}
