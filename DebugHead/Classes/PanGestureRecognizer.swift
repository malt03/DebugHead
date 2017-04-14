//
//  PanGestureRecognizer.swift
//  Pods
//
//  Created by Koji Murata on 2017/04/14.
//
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

final class PanGestureRecognizer: UIGestureRecognizer {
  private(set) var translation = CGVector.zero
  private var locationWhenTouchesBegan = CGPoint.zero
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else { return }
    locationWhenTouchesBegan = touch.location(in: view)
    state = .possible
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    guard let touch = touches.first else { return }
    let newLocation = touch.location(in: view)
    translation = CGVector(dx: newLocation.x - locationWhenTouchesBegan.x, dy: newLocation.y - locationWhenTouchesBegan.y)
    
    switch state {
    case .possible:
      if translation.abs > 10 {
        state = .began
      }
    case .began:
      state = .changed
    default:
      break
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    switch state {
    case .changed, .began:
      state = .ended
    default:
      state = .failed
    }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    switch state {
    case .changed, .began:
      state = .cancelled
    default:
      state = .failed
    }
  }
}

extension CGVector {
  var abs: CGFloat {
    return sqrt(dx * dx + dy * dy)
  }
}
