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
    
    let buttonA = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    buttonA.setTitleColor(UIColor.white, for: UIControlState())
    buttonA.setTitle("A", for: UIControlState())
    buttonA.backgroundColor = UIColor.init(colorLiteralRed: 237.0 / 255.0,
                                           green: 140.0 / 255.0,
                                           blue: 52.0 / 255.0,
                                           alpha: 1.0)
    buttonA.addTarget(self,
                      action: #selector(doActionA(_:)),
                      for: .touchUpInside)
    
    let buttonB = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    buttonB.setTitleColor(UIColor.white, for: UIControlState())
    buttonB.setTitle("B", for: UIControlState())
    buttonB.backgroundColor = UIColor.init(colorLiteralRed: 140.0 / 255.0,
                                           green: 155.0 / 255.0,
                                           blue: 237.0 / 255.0,
                                           alpha: 1.0)
    buttonB.addTarget(self,
                      action: #selector(doActionB(_:)),
                      for: .touchUpInside)
    
    
    let buttonC = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    buttonC.setTitleColor(UIColor.white, for: UIControlState())
    buttonC.setTitle("C", for: UIControlState())
    buttonC.backgroundColor = UIColor.init(colorLiteralRed: 237.0 / 255.0,
                                           green: 140 / 255.0,
                                           blue: 200.0 / 255.0,
                                           alpha: 1.0)
    buttonC.addTarget(self,
                      action: #selector(doActionC(_:)),
                      for: .touchUpInside)
    
    let buttonD = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    buttonD.setTitleColor(UIColor.white, for: UIControlState())
    buttonD.setTitle("D", for: UIControlState())
    buttonD.backgroundColor = UIColor.init(colorLiteralRed: 237.0 / 255.0,
                                           green: 100.0 / 255.0,
                                           blue: 100.0 / 255.0,
                                           alpha: 1.0)
    buttonD.addTarget(self,
                      action: #selector(doActionD(_:)),
                      for: .touchUpInside)
    
    self.edgeMenu = DPEdgeMenu.init(
      items: [buttonA, buttonB, buttonC, buttonD],
      animationDuration: 0.8,
      menuPosition: .right) // four directions
    
    self.edgeMenu?.backgroundColor = UIColor.clear
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
  
  func doActionA(_ sender: AnyObject?) {
    self.refreshLog("[A]")
  }
  
  func doActionB(_ sender: AnyObject?) {
    self.refreshLog("[B]")
  }
  
  func doActionC(_ sender: AnyObject?) {
    self.refreshLog("[C]")
  }
  
  func doActionD(_ sender: AnyObject?) {
    self.refreshLog("[D]")
  }
  
  func refreshLog(_ logInfo: String) {
    self.logInfo += logInfo
    self.logLabel.text = self.logInfo
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

