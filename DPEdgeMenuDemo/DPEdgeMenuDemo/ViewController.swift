//
//  ViewController.swift
//  DPEdgeMenuDemo
//
//  Created by Hongli Yu on 8/30/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  fileprivate var edgeMenu: DPEdgeMenu?
  fileprivate var logInfo: String = "Log:"
  
  @IBOutlet var logLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let buttonA = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    buttonA.setTitleColor(UIColor.white, for: .normal)
    buttonA.setTitle("A", for: .normal)
    buttonA.backgroundColor = UIColor(red: 237.0 / 255.0, green: 140.0 / 255.0,
                                      blue: 52.0 / 255.0, alpha: 1.0)
    buttonA.addTarget(self, action: #selector(doActionA(_:)), for: .touchUpInside)
    
    let buttonB = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    buttonB.setTitleColor(UIColor.white, for: .normal)
    buttonB.setTitle("B", for: .normal)
    buttonB.backgroundColor = UIColor(red: 140.0 / 255.0, green: 155.0 / 255.0,
                                      blue: 237.0 / 255.0, alpha: 1.0)
    buttonB.addTarget(self, action: #selector(doActionB(_:)), for: .touchUpInside)
    
    let buttonC = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    buttonC.setTitleColor(UIColor.white, for: .normal)
    buttonC.setTitle("C", for: .normal)
    buttonC.backgroundColor = UIColor(red: 237.0 / 255.0, green: 140 / 255.0,
                                      blue: 200.0 / 255.0, alpha: 1.0)
    buttonC.addTarget(self, action: #selector(doActionC(_:)), for: .touchUpInside)
    
    let buttonD = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    buttonD.setTitleColor(UIColor.white, for: .normal)
    buttonD.setTitle("D", for: .normal)
    buttonD.backgroundColor = UIColor(red: 237.0 / 255.0, green: 100.0 / 255.0,
                                      blue: 100.0 / 255.0, alpha: 1.0)
    buttonD.addTarget(self, action: #selector(doActionD(_:)), for: .touchUpInside)
    
    self.edgeMenu = DPEdgeMenu(items: [buttonA, buttonB, buttonC, buttonD],
                               animationDuration: 0.8, menuPosition: .right)
    guard let edgeMenu = self.edgeMenu else { return }
    edgeMenu.backgroundColor = UIColor.clear
    edgeMenu.itemSpacing = 5.0
    edgeMenu.animationDuration = 0.5
    edgeMenu.open()
    
    weak var weakSelf = self
    self.view.setMenuActionWithBlock { (tapGesture) in
      let strongSelf = weakSelf
      strongSelf!.updateSideBar()
    }
    
    self.view.addSubview(edgeMenu)
    self.view.backgroundColor = UIColor(red: 86 / 255.0, green: 202 / 255.0,
                                        blue: 139 / 255.0, alpha: 1.0)
  }
  
  func updateSideBar() {
    guard let edgeMenu = self.edgeMenu else { return }
    edgeMenu.opened == true ? edgeMenu.close() : edgeMenu.open()
  }
  
  func refreshLog(_ logInfo: String) {
    self.logInfo += logInfo
    self.logLabel.text = self.logInfo
  }

  @objc func doActionA(_ sender: UIButton?) {
    self.refreshLog("[A]")
  }
  
  @objc func doActionB(_ sender: UIButton?) {
    self.refreshLog("[B]")
  }
  
  @objc func doActionC(_ sender: UIButton?) {
    self.refreshLog("[C]")
  }
  
  @objc func doActionD(_ sender: UIButton?) {
    self.refreshLog("[D]")
  }
  
}
