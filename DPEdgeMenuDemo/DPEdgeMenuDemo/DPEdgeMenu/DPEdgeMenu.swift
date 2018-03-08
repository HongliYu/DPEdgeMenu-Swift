//
//  DPEdgeMenu.swift
//  DPEdgeMenuDemo
//
//  Created by Hongli Yu on 8/30/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit
import ObjectiveC
import QuartzCore

var kActionHandlerTapBlockKey: UInt8 = 0

typealias TapGestureClosure = ((_ tapGesture: UITapGestureRecognizer)->Void)
typealias EasingClosure = ((CGFloat, CGFloat, CGFloat, CGFloat)->CGFloat)

public class ClosureWrapper: NSObject, NSCopying {
  // tricks: convert Closure to AnyObject, wrapper it...
  
  fileprivate var closure: TapGestureClosure?
  
  override init() {
    super.init()
  }
  
  init(_ closure: TapGestureClosure?) {
    self.closure = closure
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    let closureWrapper: ClosureWrapper = ClosureWrapper()
    closureWrapper.closure = self.closure
    return closureWrapper
  }

}

extension UIView {
  
  func setOpacity(opacity: Float) {
    self.layer.opacity = opacity
  }
  
  func setMenuActionWithBlock(actionBlock: TapGestureClosure?) {
    let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
    self.addGestureRecognizer(gesture)
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, ClosureWrapper(actionBlock),
                             objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
  }
  
  @objc func tapAction(_ gesture: UITapGestureRecognizer) {
    if gesture.state == .recognized {
      let closureWrapper = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey) as? ClosureWrapper
      let actionBlock = closureWrapper?.closure
      actionBlock?(gesture)
    }
  }
  
}

// DPSideMenuPosition
public enum DPBoundaryMenuPosition: Int {
  case left = 0
  case top
  case right
  case bottom
}

let kAnimationDelay: Double = 0.08
let kDefaultAnimationDuration: CGFloat = 1.3

public class DPEdgeMenu: UIView {

  var opened = false
  var animationDuration = kDefaultAnimationDuration
  var menuPosition: DPBoundaryMenuPosition?
  var items: [UIView]?
  var itemSpacing: CGFloat?
  
  private var isMenuVertical: Bool {
    get {
      return (self.menuPosition == .left || self.menuPosition == .right)
    }
  }
  private var menuWidth: CGFloat?
  private var menuHeight: CGFloat?
  
  public init(items: [UIView]?) {
    super.init(frame: CGRect.zero)
    self.resetItems(items)
    self.menuPosition = .right
  }
  
  public init(items: [UIView]?, animationDuration: CGFloat?,
              menuPosition: DPBoundaryMenuPosition?) {
    super.init(frame: CGRect.zero)
    self.resetItems(items)
    self.animationDuration = animationDuration ?? kDefaultAnimationDuration
    self.menuPosition = menuPosition ?? .right
  }
  
  private func resetItems(_ items: [UIView]?) {
    if items != nil {
      for item: UIView in items! {
        item.layer.opacity = 0
        item.removeFromSuperview()
      }
      self.items = items
      for item: UIView in items! {
        self.addSubview(item)
      }
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func open() {
    self.opened = true
    guard let items = self.items else { return }
    for (index, element) in items.enumerated() {
      let delayInSeconds: Double = Double(kAnimationDelay * Double(index))
      DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
        self.showItem(item: element)
      }
    }
  }
  
  public func close() {
    self.opened = false
    guard let items = self.items else { return }
    for (index, element) in items.enumerated() {
      let delayInSeconds: Double = Double(kAnimationDelay * Double(index))
      DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
        self.hideItem(item: element)
      }
    }
  }
  
  @objc private func showItem(item: UIView?) {
    guard let item = item else { return }
    item.layer.opacity = 1.0
    var position: CGPoint = item.layer.position
    if self.isMenuVertical {
      position.x = self.menuWidth! / 2.0
      position.x += self.menuPosition == .right ? -self.menuWidth! : self.menuWidth!
      self.animate(layer: item.layer,
                   keyPath: "position.x",
                   endValue: position.x)
    } else {
      position.y = self.menuHeight! / 2.0
      position.y += self.menuPosition == .top ? self.menuHeight! : -self.menuHeight!
      self.animate(layer: item.layer,
                   keyPath: "position.y",
                   endValue: position.y)
    }
    item.layer.position = position
  }
  
  @objc private func hideItem(item: UIView?) {
    guard let item = item, let menuWidth = self.menuWidth,
      let menuHeight = self.menuHeight else { return }
    
    var position: CGPoint = item.layer.position
    if self.isMenuVertical {
      position.x = menuPosition == .right ? -menuWidth / 2.0 : menuWidth * 1.5
      position.x += menuPosition == .right ? menuWidth : -menuWidth
      self.animate(layer: item.layer, keyPath: "position.x", endValue: position.x)
    } else {
      position.y = menuPosition == .top ? menuHeight * 1.5 : -menuHeight / 2.0
      position.y += menuPosition == .top ? -menuHeight : menuHeight
      self.animate(layer: item.layer, keyPath: "position.y", endValue: position.y)
    }
    item.layer.position = position
    item.setOpacity(opacity: 0.5)
  }
  
  // MARK: UIView
  override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    for item in self.items! {
      if (item.frame.contains(point)) {
        return true
      }
    }
    return false
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    guard let items = self.items else { return }
    
    self.menuWidth = 0
    self.menuHeight = 0
    var biggestHeight: CGFloat = 0
    var biggestWidth: CGFloat = 0
    
    // Calculate the menu size
    if self.isMenuVertical {
      for item in items.enumerated() {
        self.menuWidth = max(item.element.frame.size.width , self.menuWidth!)
        biggestHeight = max(item.element.frame.size.height, biggestHeight)
      }
      self.menuHeight = (biggestHeight * CGFloat(self.items!.count))
        + (self.itemSpacing! * (CGFloat(self.items!.count) - 1))
    } else {
      for item in items.enumerated() {
        self.menuHeight = max(item.element.frame.size.height, self.menuHeight!)
        biggestWidth = max(item.element.frame.size.width, biggestWidth)
      }
      self.menuWidth = (biggestWidth * CGFloat(self.items!.count))
        + (self.itemSpacing! * (CGFloat(self.items!.count) - 1))
    }
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var itemInitialX: CGFloat = 0
    
    if self.isMenuVertical {
      x = self.menuPosition == .right ? self.superview!.frame.size.width : 0 - self.menuWidth!
      y  = (self.superview!.frame.size.height / 2.0) - (self.menuHeight! / 2.0)
      itemInitialX = self.menuWidth! / 2.0
    } else {
      x = self.superview!.frame.size.width / 2.0 - (self.menuWidth! / 2.0)
      y = self.menuPosition == .top ? 0 - self.menuHeight! : self.superview!.frame.size.height
    }
    self.frame = CGRect(x: x, y: y, width: self.menuWidth!, height: self.menuHeight!)
    // Layout the items
    for (index, element) in items.enumerated() {
      if self.isMenuVertical {
        element.center = CGPoint(x: itemInitialX, y: (CGFloat(index) * biggestHeight)
          + (CGFloat(index) * self.itemSpacing!) + (biggestHeight / 2.0))
        var position: CGPoint = element.layer.position
        if self.opened {
          position.x = self.menuPosition == .right ? -self.menuWidth! / 2.0 : self.menuWidth! * 1.5
        } else {
          position.x = self.menuWidth! / 2.0
        }
        element.layer.position = position
      } else {
        element.center = CGPoint(x: (CGFloat(index) * biggestWidth) + (CGFloat(index) * self.itemSpacing!) + (biggestWidth / 2.0),
                                 y: self.menuHeight! / 2.0)
        var position: CGPoint = element.layer.position
        if self.opened {
          position.y = self.menuPosition == .top ? self.menuHeight! * 1.5 : -self.menuHeight! / 2.0
        } else {
          position.y = self.menuHeight! / 2.0
        }
        element.layer.position = position
      }
    }
    
  }
  
  // MARK: Animation
  private func animate(layer: CALayer?, keyPath: String?, endValue: CGFloat?) {
    let startValue: CGFloat = layer!.value(forKeyPath: keyPath!) as! CGFloat
    let animation: CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: keyPath)
    animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
    animation.fillMode = kCAFillModeForwards
    animation.isRemovedOnCompletion = false
    animation.duration = Double(animationDuration)
    let steps: CGFloat = 100
    let delta: CGFloat = endValue! - startValue
    let function: EasingClosure = easeOutElastic
    var values: [CGFloat] = []
    values.reserveCapacity(100)
    for i in 0...Int(steps) {
      values.append(function(CGFloat(animation.duration) * (CGFloat(i) / steps),
        startValue, delta, CGFloat(animation.duration)))
    }
    animation.values = values
    layer!.add(animation, forKey: nil)
  }
  
  let easeOutElastic: EasingClosure = { (t: CGFloat, b: CGFloat,
    c: CGFloat, d: CGFloat) -> CGFloat in
    var amplitude: CGFloat = 5.0
    var period: CGFloat = 0.6
    var s: CGFloat = 0
    var t: CGFloat = t
    if t == 0 {
      return b
    } else if (t / d) == 1.0 {
      return b + c
    }
    if amplitude < fabs(c) {
      amplitude = c
      s = period / 4.0
    } else {
      s = period / (2 * CGFloat(Double.pi)) * sin(c / amplitude)
    }
    return (amplitude * pow(2, -10 * t) * sin((t * d - s) * (2 * CGFloat(Double.pi)) / period) + c + b)
  }

}
