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

open class ClosureWrapper: NSObject, NSCopying { // tricks: convert Closure to AnyObject, wrapper it...
  
  var closure: TapGestureClosure?
  
  override init() {
    super.init()
  }
  
  init(_ closure: TapGestureClosure?) {
    self.closure = closure
  }
  
  open func copy(with zone: NSZone?) -> Any {
    let closureWrapper: ClosureWrapper = ClosureWrapper.init()
    closureWrapper.closure = self.closure
    return closureWrapper
  }
  
}

extension UIView {
  
  func setOpacity(_ opacity: Float) {
    self.layer.opacity = opacity
  }
  
  func setMenuActionWithBlock(_ actionBlock: TapGestureClosure?) {
    let gesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self,
                                                                      action: #selector(tapActionHandler(_:)))
    self.addGestureRecognizer(gesture)
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey,
                             ClosureWrapper(actionBlock), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
  }
  
  func tapActionHandler(_ gesture: UITapGestureRecognizer) {
    if gesture.state == .recognized {
      let closureWrapper: ClosureWrapper? = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey) as? ClosureWrapper
      let actionBlock: TapGestureClosure? = closureWrapper?.closure
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
  
  var description: String {
    switch self {
    case .left:
      return "DPBoundaryMenuPositionLeft"
    case .top:
      return "DPBoundaryMenuPositionTop"
    case .right:
      return "DPBoundaryMenuPositionRight"
    case .bottom:
      return "DPBoundaryMenuPositionBottom"
    }
  }
  
}

let kAnimationDelay: Double = 0.08
let kDefaultAnimationDuration: CGFloat = 1.3

open class DPEdgeMenu: UIView {

  var opened: Bool?
  var animationDuration: CGFloat?
  var menuPosition: DPBoundaryMenuPosition?
  var items: [UIView]?
  var itemSpacing: CGFloat?
  
  fileprivate var menuIsVertical: Bool? {
    set(menuIsVertical) {
      self.menuIsVertical = menuIsVertical
    }
    get {
      if self.menuPosition == .left || self.menuPosition == .right {
        return true
      }
      return false
    }
  }
  fileprivate var menuWidth: CGFloat?
  fileprivate var menuHeight: CGFloat?
  
  public init(items: [UIView]?) {
    super.init(frame: CGRect.zero)
    self.resetItems(items)
    self.animationDuration = kDefaultAnimationDuration
    self.menuPosition = .right
  }
  
  public init(items: [UIView]?,
              animationDuration: CGFloat?,
              menuPosition: DPBoundaryMenuPosition?) {
    super.init(frame: CGRect.zero)
    self.resetItems(items)
    self.animationDuration = animationDuration ?? kDefaultAnimationDuration
    self.menuPosition = menuPosition ?? .right
  }
  
  fileprivate func resetItems(_ items: [UIView]?) {
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
  
  open func open() {
    self.opened = true
    if self.items != nil {
      for item in self.items!.enumerated() {
        let delayInSeconds: Float = Float(kAnimationDelay * Double(item.offset))
        let popTime: DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
          self.showItem(item.element)
        }
      }
    }
  }
  
  open func close() {
    self.opened = false
    if self.items != nil {
      for item in self.items!.enumerated() {
        let delayInSeconds: Float = Float(kAnimationDelay * Double(item.offset))
        let popTime: DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
          self.hideItem(item.element)
        }
      }
    }
  }
  
  @objc fileprivate func showItem(_ item: UIView?) {
    if item == nil {
      return
    }
    item!.layer.opacity = 1.0
    var position: CGPoint = item!.layer.position
    if self.menuIsVertical == true {
      position.x = self.menuWidth! / 2.0 // TODO: mark
      position.x += self.menuPosition == .right ? -self.menuWidth! : self.menuWidth!
      self.animate(item!.layer,
                   keyPath: "position.x",
                   endValue: position.x)
    } else {
      position.y = self.menuHeight! / 2.0
      position.y += self.menuPosition == .top ? self.menuHeight! : -self.menuHeight!
      self.animate(item!.layer,
                   keyPath: "position.y",
                   endValue: position.y)
    }
    item!.layer.position = position
  }
  
  @objc fileprivate func hideItem(_ item: UIView?) {
    if item == nil || self.menuWidth == nil || self.menuHeight == nil {
      return
    }
    var position: CGPoint = item!.layer.position
    if self.menuIsVertical == true {
      position.x = self.menuPosition == .right ? -self.menuWidth! / 2.0 : self.menuWidth! * 1.5
      position.x += self.menuPosition == .right ? self.menuWidth! : -self.menuWidth!
      self.animate(item!.layer,
                   keyPath: "position.x",
                   endValue: position.x)
    } else {
      position.y = self.menuPosition == .top ? self.menuHeight! * 1.5 : -self.menuHeight! / 2.0
      position.y += self.menuPosition == .top ? -self.menuHeight! : self.menuHeight!
      self.animate(item!.layer,
                   keyPath: "position.y",
                   endValue: position.y)
    }
    item!.layer.position = position
    item!.setOpacity(0.5)
  }
  
  // MARK: UIView
  override open func point(inside point: CGPoint,
                                   with event: UIEvent?) -> Bool {
    for item in self.items! {
      if (item.frame.contains(point)) {
        return true
      }
    }
    return false
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    
    if self.items == nil {
      return
    }
    
    self.menuWidth = 0
    self.menuHeight = 0
    var biggestHeight: CGFloat = 0
    var biggestWidth: CGFloat = 0
    
    // Calculate the menu size
    if (self.menuIsVertical == true) {
      for item in self.items!.enumerated() {
        self.menuWidth = max(item.element.frame.size.width , self.menuWidth!)
        biggestHeight = max(item.element.frame.size.height, biggestHeight)
      }
      self.menuHeight = (biggestHeight * CGFloat(self.items!.count))
        + (self.itemSpacing! * (CGFloat(self.items!.count) - 1))
    } else {
      for item in self.items!.enumerated() {
        self.menuHeight = max(item.element.frame.size.height, self.menuHeight!)
        biggestWidth = max(item.element.frame.size.width, biggestWidth)
      }
      self.menuWidth = (biggestWidth * CGFloat(self.items!.count))
        + (self.itemSpacing! * (CGFloat(self.items!.count) - 1))
    }
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var itemInitialX: CGFloat = 0
    
    if self.menuIsVertical == true {
      x = self.menuPosition == .right ? self.superview!.frame.size.width : 0 - self.menuWidth!
      y  = (self.superview!.frame.size.height / 2.0) - (self.menuHeight! / 2.0)
      itemInitialX = self.menuWidth! / 2.0
    } else {
      x = self.superview!.frame.size.width / 2.0 - (self.menuWidth! / 2.0)
      y = self.menuPosition == .top ? 0 - self.menuHeight! : self.superview!.frame.size.height
    }
    self.frame = CGRect(x: x, y: y, width: self.menuWidth!, height: self.menuHeight!)
    // Layout the items
    for item in self.items!.enumerated() {
      if self.menuIsVertical == true {
        item.element.center = CGPoint(x: itemInitialX, y: (CGFloat(item.offset) * biggestHeight)
          + (CGFloat(item.offset) * self.itemSpacing!) + (biggestHeight / 2.0))
        
        var position: CGPoint = item.element.layer.position
        if self.opened == true {
          position.x = self.menuPosition == .right ? -self.menuWidth! / 2.0 : self.menuWidth! * 1.5
        } else {
          position.x = self.menuWidth! / 2.0 // TODO: mark
        }
        item.element.layer.position = position
        
      } else {
        item.element.center = CGPoint(x: (CGFloat(item.offset) * biggestWidth)
          + (CGFloat(item.offset) * self.itemSpacing!) + (biggestWidth / 2.0), y: self.menuHeight! / 2.0)
        
        var position: CGPoint = item.element.layer.position
        if self.opened == true {
          position.y = self.menuPosition == .top ? self.menuHeight! * 1.5 : -self.menuHeight! / 2.0
        } else {
          position.y = self.menuHeight! / 2.0
        }
        item.element.layer.position = position
        
      }
    }
    
  }
  
  // MARK: Animation
  fileprivate func animate(_ layer: CALayer?,
                       keyPath: String?,
                       endValue: CGFloat?) {
    let startValue: CGFloat = layer!.value(forKeyPath: keyPath!) as! CGFloat
    let animation: CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: keyPath)
    animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
    animation.fillMode = kCAFillModeForwards
    animation.isRemovedOnCompletion = false
    animation.duration = Double(self.animationDuration!)
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
      s = period / (2 * CGFloat(M_PI)) * sin(c / amplitude)
    }
    return (amplitude * pow(2, -10 * t) * sin((t * d - s) * (2 * CGFloat(M_PI)) / period) + c + b)
  }

}
