//
//  DPClosureWrapper.swift
//  DPEdgeMenuDemo
//
//  Created by Hongli Yu on 2018/12/25.
//  Copyright © 2018 Hongli Yu. All rights reserved.
//

import UIKit

var kActionHandlerTapBlockKey: UInt8 = 0

typealias TapGestureClosure = ((_ tapGesture: UITapGestureRecognizer)->Void)

open class DPClosureWrapper: NSObject, NSCopying {
  
  var closure: TapGestureClosure?
  
  override init() {
    super.init()
  }
  
  init(_ closure: TapGestureClosure?) {
    self.closure = closure
  }
  
  open func copy(with zone: NSZone?) -> Any {
    let closureWrapper = DPClosureWrapper()
    closureWrapper.closure = self.closure
    return closureWrapper
  }
  
}

extension UIView {
  
  func setOpacity(_ opacity: Float) {
    layer.opacity = opacity
  }
  
  func setMenu(_ actionBlock: TapGestureClosure?) {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tapActionHandler(_:)))
    addGestureRecognizer(gesture)
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey,
                             DPClosureWrapper(actionBlock),
                             objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
  }
  
  @objc func tapActionHandler(_ gesture: UITapGestureRecognizer) {
    guard gesture.state == .recognized,
      let closureWrapper =
      objc_getAssociatedObject(self, &kActionHandlerTapBlockKey) as? DPClosureWrapper
      else {
        return
    }
    let actionBlock = closureWrapper.closure
    actionBlock?(gesture)
  }
  
}
