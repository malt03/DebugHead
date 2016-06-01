//
//  BugImageView.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/31.
//
//

import UIKit

public class BugImageView: UIView {
  @IBInspectable public var bugSize: CGFloat = 50
  @IBInspectable public var bugLineWidth: CGFloat = 1
  @IBInspectable public var bugColor: UIColor = .blackColor()
  
  public override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    BugImageCreator.drawToCurrentContext(size: bugSize, center: CGPoint(x: rect.width / 2, y: rect.height / 2), lineWidth: bugLineWidth, color: bugColor)
  }
}
