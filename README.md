# DPEdgeMenu-Swift
simple menu appear from four directions of screen edge

[![Cocoapods](https://img.shields.io/cocoapods/v/DPEdgeMenu.svg)](http://cocoapods.org/?q=DPEdgeMenu)
[![Pod License](http://img.shields.io/cocoapods/l/DPEdgeMenu.svg)](https://github.com/HongliYu/DPEdgeMenu-Swift/blob/master/LICENSE)
[![Swift-4.2](https://img.shields.io/badge/Swift-4.2-blue.svg)]()
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![screenshot](https://github.com/HongliYu/DPEdgeMenu-Swift/blob/master/DPEdgeMenu.gif?raw=true)


# Usage

```  swift
  // 1. Make an array of related buttons
  
    var buttons = [UIButton]()
    let letters = ["A", "B", "C", "D"]
    let colors = [UIColor(red: 237.0 / 255.0, green: 140.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0),
                  UIColor(red: 140.0 / 255.0, green: 155.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0),
                  UIColor(red: 237.0 / 255.0, green: 140 / 255.0, blue: 200.0 / 255.0, alpha: 1.0),
                  UIColor(red: 237.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)]
    let items = zip(letters, colors).map { $0 }
    for item in items.enumerated() {
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
      button.setTitleColor(.white, for: .normal)
      button.setTitle(item.element.0, for: .normal)
      button.backgroundColor = item.element.1
      button.tag = item.offset
      button.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
      buttons.append(button)
    }

  
  // 2. Cconfig basic params
    edgeMenu.config(buttons)
    edgeMenu.animationDuration = 0.8
    edgeMenu.menuPosition = .right
    edgeMenu.open()

    view.setMenu { [weak self] gesture in
      guard let strongSelf = self else { return }
      strongSelf.updateSideBar()
    }
    
    view.addSubview(edgeMenu)
    view.backgroundColor = UIColor(red: 86 / 255.0, green: 202 / 255.0,
                                   blue: 139 / 255.0, alpha: 1.0)
}
```
