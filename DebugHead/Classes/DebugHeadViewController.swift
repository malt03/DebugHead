//
//  DebugHeadViewController.swift
//  Pods
//
//  Created by Koji Murata on 2017/07/25.
//
//

import UIKit

final class DebugHeadViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.cornerRadius = 4
    view.layer.masksToBounds = true
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.borderWidth = 1
  }
}
