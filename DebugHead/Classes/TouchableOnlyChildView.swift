//
//  TouchableOnlyChildView.swift
//  Pods
//
//  Created by Koji Murata on 2017/04/14.
//
//

import UIKit

final class TouchableOnlyChildView: UIView {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    for v in subviews {
      if let hit = v.hitTest(convert(point, to: v), with: event) {
        return hit
      }
    }
    return nil
  }
}
