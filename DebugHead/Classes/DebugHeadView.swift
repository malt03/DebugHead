//
//  DebugHeadView.swift
//  Pods
//
//  Created by Koji Murata on 2017/04/14.
//
//

import UIKit
import BugImageCreator

final class DebugHeadView: BugImageView {
  override func awakeFromNib() {
    super.awakeFromNib()

    layer.cornerRadius = 4
    layer.masksToBounds = true
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1

//    let panGestureRecognizer = PanGestureRecognizer(target: self, action: #selector(panned(_:)))
    //    let forceTouchGestureRecognizer = FourceTouchGestureRecognizer(target: self, action: #selector(fourceTouched))
    
//    addGestureRecognizer(panGestureRecognizer)
    //    addGestureRecognizer(forceTouchGestureRecognizer)
}
  
  private var originInSuperviewWhenBeganPan: CGPoint?
  @objc private func panned(_ recognizer: PanGestureRecognizer) {
    
  }
}
