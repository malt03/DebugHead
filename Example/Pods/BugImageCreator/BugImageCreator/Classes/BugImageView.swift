//
//  BugImageView.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/31.
//
//

import UIKit

public class BugImageView: UIView {
  @IBInspectable public var size: CGFloat = 50
  @IBInspectable public var lineWidth: CGFloat = 1
  @IBInspectable public var color: UIColor = .blackColor()
  
  private let bugLayer = CALayer()
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepare()
  }
  
  private func prepare() {
    layer.addSublayer(bugLayer)
  }
  
  public override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    bugLayer.contents = BugImageCreator.getCacheOrCreate(size: size, lineWidth: lineWidth, color: color).CGImage
    bugLayer.frame = CGRect(x: (rect.width - size) / 2, y: (rect.height - size) / 2, width: size, height: size)
  }
}
