//
//  ViewController.swift
//  DPEdgeMenuDemo
//
//  Created by Hongli Yu on 8/30/16.
//  Copyright © 2016 Hongli Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var logLabel: UILabel!
  var edgeMenu: DPEdgeMenu = DPEdgeMenu()
  var logInfo: String = "Log:"

  override func viewDidLoad() {
    super.viewDidLoad()

    var buttons = [UIButton]()
    let letters = ["A", "B", "C", "D"]
    let items = zip(letters, Colors.buttonColors).map { $0 }
    for item in items.enumerated() {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
      button.setTitleColor(.white, for: .normal)
      button.setTitle(item.element.0, for: .normal)
      button.backgroundColor = item.element.1
      button.tag = item.offset
      button.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
      buttons.append(button)
    }
    
    edgeMenu.config(buttons)
    edgeMenu.animationDuration = 0.8
    edgeMenu.menuPosition = .top
    edgeMenu.open()

    view.setMenu { [weak self] gesture in
      guard let strongSelf = self else { return }
      strongSelf.updateSideBar()
    }
    
    view.addSubview(edgeMenu)
    view.backgroundColor = Colors.backgroundColor
  }
  
  func updateSideBar() {
    edgeMenu.opened ? edgeMenu.close() : edgeMenu.open()
  }
  
  @objc func doAction(_ sender: UIButton?) {
    switch sender?.tag {
    case 0:
      refreshLog("[A]")
    case 1:
      refreshLog("[B]")
    case 2:
      refreshLog("[C]")
    case 3:
      refreshLog("[D]")
    default:
      break
    }
  }
  
  func refreshLog(_ logInfo: String) {
    self.logInfo += logInfo
    self.logLabel.text = self.logInfo
  }

}

struct Colors {
  static let buttonColors = [UIColor(red: 237.0 / 255.0, green: 140.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0),
                             UIColor(red: 140.0 / 255.0, green: 155.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0),
                             UIColor(red: 237.0 / 255.0, green: 140 / 255.0, blue: 200.0 / 255.0, alpha: 1.0),
                             UIColor(red: 237.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)]
  static let backgroundColor = UIColor(red: 86 / 255.0, green: 202 / 255.0,
                                       blue: 139 / 255.0, alpha: 1.0)
}
