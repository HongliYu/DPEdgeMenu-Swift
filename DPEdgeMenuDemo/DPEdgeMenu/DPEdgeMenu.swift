//
//  DPEdgeMenu.swift
//  DPEdgeMenuDemo
//
//  Created by Hongli Yu on 8/30/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

typealias EasingClosure = ((CGFloat, CGFloat, CGFloat, CGFloat) -> CGFloat)

public enum DPBoundaryMenuPosition: Int {
  
  case left = 0
  case top
  case right
  case bottom
  
  var description: String {
    switch self {
    case .left:
      return "left"
    case .top:
      return "top"
    case .right:
      return "right"
    case .bottom:
      return "bottom"
    }
  }
  
}

open class DPEdgeMenu: UIView {
  
  private let kAnimationDelay: Double = 0.08
  open var animationDuration: Double = 1.2
  open var menuPosition: DPBoundaryMenuPosition = .right
  open var itemSpacing: CGFloat = 8.0
  open var opened: Bool = false
  open var items: [UIView]?

  private var menuIsVertical: Bool {
    get {
      return (menuPosition == .left || menuPosition == .right)
    }
  }
  private var menuWidth: CGFloat = 0
  private var menuHeight: CGFloat = 0
  
  public init() {
    super.init(frame: CGRect.zero)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func config(_ items: [UIView]) {
    self.resetItems(items)
  }
  
  private func resetItems(_ items: [UIView]) {
    items.forEach {
      $0.layer.opacity = 0
      $0.removeFromSuperview()
    }
    self.items = items
    items.forEach {
      addSubview($0)
    }
  }
  
  public func open() {
    guard let items = self.items else { return }
    opened = true
    for item in items.enumerated() {
      let delayInSeconds: Float = Float(kAnimationDelay * Double(item.offset))
      let popTime: DispatchTime = DispatchTime.now()
        + Double(Int64(delayInSeconds * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: popTime) {
        self.showItem(item.element)
      }
    }
  }
  
  public func close() {
    guard let items = self.items else { return }
    opened = false
    for item in items.enumerated() {
      let delayInSeconds: Float = Float(kAnimationDelay * Double(item.offset))
      let popTime: DispatchTime = DispatchTime.now()
        + Double(Int64(delayInSeconds * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: popTime) {
        self.hideItem(item.element)
      }
    }
  }
  
  private func showItem(_ item: UIView?) {
    guard let item = item else { return }
    item.layer.opacity = 1.0
    var position: CGPoint = item.layer.position
    if menuIsVertical {
      position.x = menuWidth / 2.0
      position.x += (menuPosition == .right) ? (-menuWidth) : menuWidth
      animate(item.layer, keyPath: "position.x", endValue: position.x)
    } else {
      position.y = menuHeight / 2.0
      position.y += (menuPosition == .top) ? menuHeight : (-menuHeight)
      animate(item.layer, keyPath: "position.y", endValue: position.y)
    }
    item.layer.position = position
  }
  
  private func hideItem(_ item: UIView?) {
    guard let item = item else { return }
    var position: CGPoint = item.layer.position
    if menuIsVertical {
      position.x = (menuPosition == .right) ? (-menuWidth / 2.0) : menuWidth * 1.5
      position.x += (menuPosition == .right) ? menuWidth : -menuWidth
      animate(item.layer, keyPath: "position.x", endValue: position.x)
    } else {
      position.y = (menuPosition == .top) ? menuHeight * 1.5 : (-menuHeight / 2.0)
      position.y += (menuPosition == .top) ? (-menuHeight) : menuHeight
      animate(item.layer, keyPath: "position.y", endValue: position.y)
    }
    item.layer.position = position
    item.setOpacity(0.5)
  }
  
  override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    guard let items = items else { return false }
    let rets = items.compactMap {
      $0.frame.contains(point)
    }
    return rets.contains(true)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    
    guard let items = items, let superview = superview else { return }
    var biggestHeight: CGFloat = 0
    var biggestWidth: CGFloat = 0
    
    // Calculate the menu size
    if menuIsVertical {
      for item in items.enumerated() {
        menuWidth = max(item.element.frame.size.width , menuWidth)
        biggestHeight = max(item.element.frame.size.height, biggestHeight)
      }
      menuHeight = (biggestHeight * CGFloat(items.count))
        + (itemSpacing * (CGFloat(items.count) - 1))
    } else {
      for item in items.enumerated() {
        menuHeight = max(item.element.frame.size.height, menuHeight)
        biggestWidth = max(item.element.frame.size.width, biggestWidth)
      }
      menuWidth = (biggestWidth * CGFloat(items.count))
        + (itemSpacing * (CGFloat(items.count) - 1))
    }
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var itemInitialX: CGFloat = 0
    
    if menuIsVertical {
      x = (menuPosition == .right) ? superview.frame.size.width : 0 - menuWidth
      y = (superview.frame.size.height / 2.0) - (menuHeight / 2.0)
      itemInitialX = menuWidth / 2.0
    } else {
      x = superview.frame.size.width / 2.0 - (menuWidth / 2.0)
      y = (menuPosition == .top) ? 0 - menuHeight : superview.frame.size.height
    }
    self.frame = CGRect(x: x, y: y, width: menuWidth, height: menuHeight)
    
    // Layout the items
    for item in items.enumerated() {
      if menuIsVertical {
        item.element.center =
          CGPoint(x: itemInitialX, y: (CGFloat(item.offset) * biggestHeight)
            + (CGFloat(item.offset) * itemSpacing) + (biggestHeight / 2.0))
        var position: CGPoint = item.element.layer.position
        if opened == true {
          position.x = (menuPosition == .right) ? -menuWidth / 2.0 : menuWidth * 1.5
        } else {
          position.x = menuWidth / 2.0
        }
        item.element.layer.position = position
      } else {
        item.element.center = CGPoint(x: (CGFloat(item.offset) * biggestWidth)
          + (CGFloat(item.offset) * itemSpacing) + (biggestWidth / 2.0), y: menuHeight / 2.0)
        var position: CGPoint = item.element.layer.position
        if opened == true {
          position.y = (menuPosition == .top) ? menuHeight * 1.5 : -menuHeight / 2.0
        } else {
          position.y = menuHeight / 2.0
        }
        item.element.layer.position = position
      }
    }
  }
  
  // MARK: Animation
  private func animate(_ layer: CALayer?, keyPath: String?, endValue: CGFloat?) {
    guard let keyPath = keyPath, let layer = layer,
      let startValue: CGFloat = layer.value(forKeyPath: keyPath) as? CGFloat,
      let endValue = endValue else {
      return
    }
    let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)
    animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.isRemovedOnCompletion = false
    animation.duration = animationDuration
    let steps: CGFloat = 100
    let delta: CGFloat = endValue - startValue
    let function: EasingClosure = easeOutElastic
    var values: [CGFloat] = []
    values.reserveCapacity(100)
    for i in 0...Int(steps) {
      values.append(function(CGFloat(animation.duration) * (CGFloat(i) / steps),
        startValue, delta, CGFloat(animation.duration)))
    }
    animation.values = values
    layer.add(animation, forKey: nil)
  }
  
  let easeOutElastic: EasingClosure = {
    (t: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat) -> CGFloat in
    var amplitude: CGFloat = 5.0
    var period: CGFloat = 0.6
    var s: CGFloat = 0
    var t: CGFloat = t
    if t == 0 {
      return b
    } else if (t / d) == 1.0 {
      return b + c
    }
    if amplitude < abs(c) {
      amplitude = c
      s = period / 4.0
    } else {
      s = period / (2 * CGFloat(Double.pi)) * sin(c / amplitude)
    }
    return (amplitude * pow(2, -10 * t) * sin((t * d - s) * (2 * CGFloat(Double.pi)) / period) + c + b)
  }

}
