//
//  FourcePressGestureRecognizer.swift
//  Pods
//
//  Created by Koji Murata on 2017/04/13.
//
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

final class FourcePressGestureRecognizer: UIGestureRecognizer {
  private let feedbackGenerator: NSObject?
  
  override init(target: Any?, action: Selector?) {
    if #available(iOS 10.0, *) {
      feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    } else {
      feedbackGenerator = nil
    }
    super.init(target: target, action: action)
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
