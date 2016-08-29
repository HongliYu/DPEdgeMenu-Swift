//
//  ViewController.swift
//  DPEdgeMenuDemo
//
//  Created by Hongli Yu on 8/30/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var edgeMenu: DPEdgeMenu?
  var logInfo: String = "Log:"
  @IBOutlet var logLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let buttonA = UIButton.init(frame: CGRectMake(0, 0, 40, 40))
    buttonA.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    buttonA.setTitle("A", forState: .Normal)
    buttonA.backgroundColor = UIColor.init(colorLiteralRed: 237.0 / 255.0,
                                           green: 140.0 / 255.0,
                                           blue: 52.0 / 255.0,
                                           alpha: 1.0)
    buttonA.addTarget(self,
                      action: #selector(doActionA(_:)),
                      forControlEvents: .TouchUpInside)
    
    let buttonB = UIButton.init(frame: CGRectMake(0, 0, 40, 40))
    buttonB.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    buttonB.setTitle("B", forState: .Normal)
    buttonB.backgroundColor = UIColor.init(colorLiteralRed: 140.0 / 255.0,
                                           green: 155.0 / 255.0,
                                           blue: 237.0 / 255.0,
                                           alpha: 1.0)
    buttonB.addTarget(self,
                      action: #selector(doActionB(_:)),
                      forControlEvents: .TouchUpInside)
    
    
    let buttonC = UIButton.init(frame: CGRectMake(0, 0, 40, 40))
    buttonC.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    buttonC.setTitle("C", forState: .Normal)
    buttonC.backgroundColor = UIColor.init(colorLiteralRed: 237.0 / 255.0,
                                           green: 140 / 255.0,
                                           blue: 200.0 / 255.0,
                                           alpha: 1.0)
    buttonC.addTarget(self,
                      action: #selector(doActionC(_:)),
                      forControlEvents: .TouchUpInside)
    
    let buttonD = UIButton.init(frame: CGRectMake(0, 0, 40, 40))
    buttonD.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    buttonD.setTitle("D", forState: .Normal)
    buttonD.backgroundColor = UIColor.init(colorLiteralRed: 237.0 / 255.0,
                                           green: 100.0 / 255.0,
                                           blue: 100.0 / 255.0,
                                           alpha: 1.0)
    buttonD.addTarget(self,
                      action: #selector(doActionD(_:)),
                      forControlEvents: .TouchUpInside)
    
    self.edgeMenu = DPEdgeMenu.init(
      items: [buttonA, buttonB, buttonC, buttonD],
      animationDuration: 0.8,
      menuPosition: .Right) // four directions
    
    self.edgeMenu?.backgroundColor = UIColor.clearColor()
    self.edgeMenu?.itemSpacing = 5.0
    self.edgeMenu?.animationDuration = 0.5
    self.edgeMenu?.open()
    
    weak var weakSelf = self
    self.view.setMenuActionWithBlock { (tapGesture) in
      let strongSelf = weakSelf
      strongSelf!.updateSideBar()
    }
    
    self.view.addSubview(self.edgeMenu!)
    self.view.backgroundColor = UIColor.init(red: 86 / 255.0,
                                             green: 202 / 255.0,
                                             blue: 139 / 255.0,
                                             alpha: 1.0)
    
  }
  
  func updateSideBar() {
    self.edgeMenu?.opened == true ? self.edgeMenu?.close() : self.edgeMenu?.open()
  }
  
  func doActionA(sender: AnyObject?) {
    self.refreshLog("[A]")
  }
  
  func doActionB(sender: AnyObject?) {
    self.refreshLog("[B]")
  }
  
  func doActionC(sender: AnyObject?) {
    self.refreshLog("[C]")
  }
  
  func doActionD(sender: AnyObject?) {
    self.refreshLog("[D]")
  }
  
  func refreshLog(logInfo: String) {
    self.logInfo += logInfo
    self.logLabel.text = self.logInfo
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

