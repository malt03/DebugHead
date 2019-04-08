//
//  CGPoint+Extension.swift
//  DebugHead
//
//  Created by Koji Murata on 2019/04/08.
//

import Foundation

extension CGPoint {
  var length: CGFloat { return sqrt(x * x + y * y) }
  func distance(to point: CGPoint) -> CGFloat {
    return CGPoint(x: x - point.x, y: y - point.y).length
  }
}
