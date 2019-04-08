//
//  CGRect+Extension.swift
//  DebugHead
//
//  Created by Koji Murata on 2019/04/08.
//

import Foundation

extension CGRect {
  func nearSidePoint(for point: CGPoint) -> CGPoint {
    let leftDistance   = point.x - left
    let topDistance    = point.y - top
    let rightDistance  = right   - point.x
    let bottomDistance = bottom  - point.y
    let minDistance = min(leftDistance, topDistance, rightDistance, bottomDistance)

    switch minDistance {
    case leftDistance:   return CGPoint(x: left,  y: (top...bottom).nearBound(for: point.y))
    case rightDistance:  return CGPoint(x: right, y: (top...bottom).nearBound(for: point.y))
    case topDistance:    return CGPoint(x: (left...right).nearBound(for: point.x), y: top)
    case bottomDistance: return CGPoint(x: (left...right).nearBound(for: point.x), y: bottom)
    default:
      // never come
      return origin
    }
  }
  
  func intersection(from point: CGPoint, velocity: CGPoint) -> CGPoint {
    let line = Line(from: point, velocity: velocity)
//    if let intersection = intersectionLeft, contains(intersection) && isSameDirection(velocity: velocity, fromPoint: point, toPoint: intersection) { return intersection }
//    if let intersection = intersectionRight, contains(intersection) && isSameDirection(velocity: velocity, fromPoint: point, toPoint: intersection) { return intersection }
//    if let intersection = intersectionTop, contains(intersection) && isSameDirection(velocity: velocity, fromPoint: point, toPoint: intersection) { return intersection }
//    if let intersection = intersectionBottom, contains(intersection) && isSameDirection(velocity: velocity, fromPoint: point, toPoint: intersection) { return intersection }

    if let intersection = line.intersection(x: left),
      isOnSide(point: intersection) && isSameDirection(velocity: velocity, fromPoint: point, toPoint: intersection) { return intersection }
    if let intersection = line.intersection(x: right),
      isOnSide(point: intersection) && isSameDirection(velocity: velocity, fromPoint: point, toPoint: intersection) { return intersection }
    if let intersection = line.intersection(y: top),
      isOnSide(point: intersection) && isSameDirection(velocity: velocity, fromPoint: point, toPoint: intersection) { return intersection }
    if let intersection = line.intersection(y: bottom),
      isOnSide(point: intersection) && isSameDirection(velocity: velocity, fromPoint: point, toPoint: intersection) { return intersection }

    // never come
    return origin
  }

  var left: CGFloat { return origin.x }
  var right: CGFloat { return origin.x + width }
  var top: CGFloat { return origin.y }
  var bottom: CGFloat { return origin.y + height }
  
  func isOnSide(point: CGPoint) -> Bool {
    if left == point.x || right == point.x { return (top...bottom).contains(point.y) }
    if top == point.y || bottom == point.y { return (left...right).contains(point.x) }
    return false
  }
}

extension ClosedRange {
  func nearBound(for value: Bound) -> Bound {
    if value < lowerBound { return lowerBound }
    if value > upperBound { return upperBound }
    return value
  }
}

fileprivate func isSameDirection(velocity: CGPoint, fromPoint: CGPoint, toPoint: CGPoint) -> Bool {
  let velocity2 = CGPoint(x: toPoint.x - fromPoint.x, y: toPoint.y - fromPoint.y)
  let x = (velocity.x == 0 && velocity2.x == 0) || (velocity.x * velocity2.x > 0)
  let y = (velocity.y == 0 && velocity2.y == 0) || (velocity.y * velocity2.y > 0)
  return x && y
}
