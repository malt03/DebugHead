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
    return .lightContent
  }
  
  @IBAction private func changeWindow() {
    UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Foo")
  }
}
