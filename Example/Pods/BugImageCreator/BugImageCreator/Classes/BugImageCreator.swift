//
//  BugImageCreator.swift
//
//  Created by Koji Murata on 2016/05/31.
//  Copyright © 2016年 Koji Murata. All rights reserved.
//

import UIKit

public class BugImageCreator {
  public class func drawToCurrentContext(size s: CGFloat, center: CGPoint, lineWidth: CGFloat, color: UIColor) {
    let cx = center.x
    let cy = center.y + s / 10
    let r = s * 3 / 8 - lineWidth / 2
    let hr = r / 2
    let a = r / 5
    let f = r / 3
    
    let context = UIGraphicsGetCurrentContext()
    color.setStroke()
    CGContextSetLineWidth(context, lineWidth)
    
    // body
    CGContextAddArc(context, cx, cy, r, -CGFloat(M_PI) / 3, -CGFloat(M_PI) / 3 * 2, 0)
    CGContextClosePath(context)
    
    // head
    let headCenter = CGPoint(x: cx, y: cy - sin(CGFloat(M_PI / 3)) * r)
    CGContextAddArc(context, headCenter.x, headCenter.y, hr, 0, CGFloat(M_PI), 1)
    
    CGContextAddLines(context, [
      CGPoint(x: cx, y: cy - sin(CGFloat(M_PI / 3)) * r),
      CGPoint(x: cx, y: cy + r),
      ], 2)
    
    // antennae
    CGContextAddLines(context, [
      CGPoint(x: headCenter.x + cos(CGFloat(M_PI) / 5 * 2) * hr, y: headCenter.y + sin(-CGFloat(M_PI) / 5 * 2) * hr),
      CGPoint(x: headCenter.x + cos(CGFloat(M_PI) / 5 * 2) * hr + a, y: headCenter.y - sin(CGFloat(M_PI) / 5 * 2) * hr - a),
      ], 2)
    CGContextAddLines(context, [
      CGPoint(x: headCenter.x - cos(CGFloat(M_PI) / 5 * 2) * hr, y: headCenter.y + sin(-CGFloat(M_PI) / 5 * 2) * hr),
      CGPoint(x: headCenter.x - cos(CGFloat(M_PI) / 5 * 2) * hr - a, y: headCenter.y - sin(CGFloat(M_PI) / 5 * 2) * hr - a),
      ], 2)
    
    // feet
    CGContextAddLines(context, [
      CGPoint(x: cx + r, y: cy),
      CGPoint(x: cx + r + f, y: cy),
      ], 2)
    CGContextAddLines(context, [
      CGPoint(x: cx + cos(CGFloat(M_PI) / 6) * r, y: cy - sin(CGFloat(M_PI) / 6) * r),
      CGPoint(x: cx + cos(CGFloat(M_PI) / 6) * (r + f), y: cy - sin(CGFloat(M_PI) / 6) * (r + f)),
      ], 2)
    CGContextAddLines(context, [
      CGPoint(x: cx + cos(CGFloat(M_PI) / 6) * r, y: cy + sin(CGFloat(M_PI) / 6) * r),
      CGPoint(x: cx + cos(CGFloat(M_PI) / 6) * (r + f), y: cy + sin(CGFloat(M_PI) / 6) * (r + f)),
      ], 2)
    CGContextAddLines(context, [
      CGPoint(x: cx - r, y: cy),
      CGPoint(x: cx - r - f, y: cy),
      ], 2)
    CGContextAddLines(context, [
      CGPoint(x: cx - cos(CGFloat(M_PI) / 6) * r, y: cy - sin(CGFloat(M_PI) / 6) * r),
      CGPoint(x: cx - cos(CGFloat(M_PI) / 6) * (r + f), y: cy - sin(CGFloat(M_PI) / 6) * (r + f)),
      ], 2)
    CGContextAddLines(context, [
      CGPoint(x: cx - cos(CGFloat(M_PI) / 6) * r, y: cy + sin(CGFloat(M_PI) / 6) * r),
      CGPoint(x: cx - cos(CGFloat(M_PI) / 6) * (r + f), y: cy + sin(CGFloat(M_PI) / 6) * (r + f)),
      ], 2)
    
    CGContextStrokePath(context)
  }
  
  public class func getCacheOrCreate(size size: CGFloat, lineWidth: CGFloat, color: UIColor) -> UIImage {
    guard let url = cacheURL(size, lineWidth, color) else { return create(size: size, lineWidth: lineWidth, color: color) }

    guard let data = NSData(contentsOfURL: url),
      unscale = UIImage(data: data),
      cgImage = unscale.CGImage else {
      let i = create(size: size, lineWidth: lineWidth, color: color)
      save(i, url: url)
      return i
    }
    
    return UIImage(CGImage: cgImage, scale: UIScreen.mainScreen().scale, orientation: .Up)
  }
  
  public class func create(size s: CGFloat, lineWidth: CGFloat, color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: s, height: s), false, 0)
    
    drawToCurrentContext(size: s, center: CGPoint(x: s / 2, y: s / 2), lineWidth: lineWidth, color: color)
    
    return UIGraphicsGetImageFromCurrentImageContext()!
  }
  
  private class func save(image: UIImage, url: NSURL) {
    guard let data = UIImagePNGRepresentation(image) else { return }
    data.writeToURL(url, atomically: true)
  }
  
  private class func cacheURL(size: CGFloat, _ lineWidth: CGFloat, _ color: UIColor) -> NSURL? {
    let fileManager = NSFileManager.defaultManager()
    guard let cacheDirectoryURL = try? fileManager.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true) else { return nil }
    let directoryURL = cacheDirectoryURL.URLByAppendingPathComponent("bug_image_creator", isDirectory: true)
    do {
      try fileManager.createDirectoryAtURL(directoryURL, withIntermediateDirectories: true, attributes: nil)
    } catch {
      return nil
    }
    return directoryURL.URLByAppendingPathComponent("s\(size)l\(lineWidth)c\(color).png")
  }
}
