//
//  BugImageCreator.swift
//
//  Created by Koji Murata on 2016/05/31.
//  Copyright © 2016年 Koji Murata. All rights reserved.
//

import UIKit

open class BugImageCreator {
  open class func drawToCurrentContext(size: CGFloat, center: CGPoint, lineWidth: CGFloat, color: UIColor) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    let cx = center.x
    let cy = center.y + size / 10
    let r = size * 3 / 8 - lineWidth / 2
    let hr = r / 2
    let a = r / 5
    let f = r / 3
    
    color.setStroke()
    context.setLineWidth(lineWidth)
    
    // body
    let bodyCenter = CGPoint(x: cx, y: cy)
    context.addArc(center: bodyCenter, radius: r, startAngle: -CGFloat(M_PI) / 3, endAngle: -CGFloat(M_PI) / 3 * 2, clockwise: false)
    context.closePath()
    
    // head
    let headCenter = CGPoint(x: cx, y: cy - sin(CGFloat(M_PI / 3)) * r)
    context.addArc(center: headCenter, radius: hr, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)

    context.addLines(between: [
      CGPoint(x: cx, y: cy - sin(CGFloat(M_PI / 3)) * r),
      CGPoint(x: cx, y: cy + r),
    ])
    
    // antennae
    context.addLines(between: [
      CGPoint(x: headCenter.x + cos(CGFloat(M_PI) / 5 * 2) * hr, y: headCenter.y + sin(-CGFloat(M_PI) / 5 * 2) * hr),
      CGPoint(x: headCenter.x + cos(CGFloat(M_PI) / 5 * 2) * hr + a, y: headCenter.y - sin(CGFloat(M_PI) / 5 * 2) * hr - a),
    ])
    context.addLines(between: [
      CGPoint(x: headCenter.x - cos(CGFloat(M_PI) / 5 * 2) * hr, y: headCenter.y + sin(-CGFloat(M_PI) / 5 * 2) * hr),
      CGPoint(x: headCenter.x - cos(CGFloat(M_PI) / 5 * 2) * hr - a, y: headCenter.y - sin(CGFloat(M_PI) / 5 * 2) * hr - a),
    ])
    
    // feet
    context.addLines(between: [
      CGPoint(x: cx + r, y: cy),
      CGPoint(x: cx + r + f, y: cy),
    ])
    context.addLines(between: [
      CGPoint(x: cx + cos(CGFloat(M_PI) / 6) * r, y: cy - sin(CGFloat(M_PI) / 6) * r),
      CGPoint(x: cx + cos(CGFloat(M_PI) / 6) * (r + f), y: cy - sin(CGFloat(M_PI) / 6) * (r + f)),
    ])
    context.addLines(between: [
      CGPoint(x: cx + cos(CGFloat(M_PI) / 6) * r, y: cy + sin(CGFloat(M_PI) / 6) * r),
      CGPoint(x: cx + cos(CGFloat(M_PI) / 6) * (r + f), y: cy + sin(CGFloat(M_PI) / 6) * (r + f)),
    ])
    context.addLines(between: [
      CGPoint(x: cx - r, y: cy),
      CGPoint(x: cx - r - f, y: cy),
    ])
    context.addLines(between: [
      CGPoint(x: cx - cos(CGFloat(M_PI) / 6) * r, y: cy - sin(CGFloat(M_PI) / 6) * r),
      CGPoint(x: cx - cos(CGFloat(M_PI) / 6) * (r + f), y: cy - sin(CGFloat(M_PI) / 6) * (r + f)),
    ])
    context.addLines(between: [
      CGPoint(x: cx - cos(CGFloat(M_PI) / 6) * r, y: cy + sin(CGFloat(M_PI) / 6) * r),
      CGPoint(x: cx - cos(CGFloat(M_PI) / 6) * (r + f), y: cy + sin(CGFloat(M_PI) / 6) * (r + f)),
    ])
    
    context.strokePath()
  }
  
  open class func getCacheOrCreate(size: CGFloat, lineWidth: CGFloat, color: UIColor) -> UIImage {
    guard let url = cacheURL(size, lineWidth, color) else { return create(size: size, lineWidth: lineWidth, color: color) }

    guard let data = try? Data(contentsOf: url),
      let unscale = UIImage(data: data),
      let cgImage = unscale.cgImage else {
      let i = create(size: size, lineWidth: lineWidth, color: color)
      save(i, url)
      return i
    }
    
    return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
  }
  
  open class func create(size: CGFloat, lineWidth: CGFloat, color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
    
    drawToCurrentContext(size: size, center: CGPoint(x: size / 2, y: size / 2), lineWidth: lineWidth, color: color)
    
    return UIGraphicsGetImageFromCurrentImageContext()!
  }
  
  fileprivate class func save(_ image: UIImage, _ url: URL) {
    guard let data = UIImagePNGRepresentation(image) else { return }
    try? data.write(to: url, options: [.atomic])
  }
  
  fileprivate class func cacheURL(_ size: CGFloat, _ lineWidth: CGFloat, _ color: UIColor) -> URL? {
    let fileManager = FileManager.default
    guard let cacheDirectoryURL = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
    let directoryURL = cacheDirectoryURL.appendingPathComponent("bug_image_creator", isDirectory: true)
    do {
      try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    } catch {
      return nil
    }
    return directoryURL.appendingPathComponent("s\(size)l\(lineWidth)c\(color).png")
  }
}
