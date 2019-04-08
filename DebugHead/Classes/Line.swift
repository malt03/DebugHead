//
//  Line.swift
//  DebugHead
//
//  Created by Koji Murata on 2019/04/08.
//

import Foundation

struct Line {
  // y = ax + b
  // x = c
  
  private let a: CGFloat
  private let b: CGFloat
  private let c: CGFloat?
  
  init(from point: CGPoint, velocity: CGPoint) {
    if velocity.x == 0 {
      a = 0
      b = 0
      c = point.x
    } else {
      a = velocity.y / velocity.x
      b = point.y - a * point.x
      c = nil
    }
  }
  
  func intersection(x: CGFloat) -> CGPoint? {
    if c != nil { return nil }
    return CGPoint(x: x, y: a * x + b)
  }
  
  func intersection(y: CGFloat) -> CGPoint? {
    if let c = c { return CGPoint(x: c, y: y) }
    if a == 0 { return nil }
    return CGPoint(x: (y - b) / a, y: y)
  }
}
