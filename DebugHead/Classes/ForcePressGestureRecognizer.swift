//
//  ForceTouchablePanGestureRecognizer.swift
//  Pods
//
//  Created by Koji Murata on 2017/04/13.
//
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

final class ForcePressGestureRecognizer: UIGestureRecognizer {
  private var feedbackGenerator: NSObject?
  override func addTarget(_ target: Any, action: Selector) {
    super.addTarget(target, action: action)
    if #available(iOS 10.0, *) {
      if feedbackGenerator == nil {
        feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
      }
    } else {
      feedbackGenerator = nil
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    if #available(iOS 10.0, *) {
      (feedbackGenerator as? UIImpactFeedbackGenerator)?.prepare()
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else { return }
    if #available(iOS 9.0, *) {
      if touch.force == touch.maximumPossibleForce {
        if #available(iOS 10.0, *) {
          (feedbackGenerator as? UIImpactFeedbackGenerator)?.impactOccurred()
        }
        state = .recognized
      }
    }
  }
}
