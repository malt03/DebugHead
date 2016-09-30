//
//  BugImageView.swift
//  Pods
//
//  Created by Koji Murata on 2016/05/31.
//
//

import UIKit

open class BugImageView: UIView {
  @IBInspectable open var bugSize: CGFloat = 50
  @IBInspectable open var bugLineWidth: CGFloat = 1
  @IBInspectable open var bugColor: UIColor = .black
  
  open override func draw(_ rect: CGRect) {
    super.draw(rect)
    BugImageCreator.drawToCurrentContext(size: bugSize, center: CGPoint(x: rect.width / 2, y: rect.height / 2), lineWidth: bugLineWidth, color: bugColor)
  }
}
