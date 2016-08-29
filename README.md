# DPEdgeMenu-Swift
simple menu appear from four directions of screen edge

[![Cocoapods](https://img.shields.io/cocoapods/v/DPEdgeMenu.svg)](http://cocoapods.org/?q=DPEdgeMenu)
[![Pod License](http://img.shields.io/cocoapods/l/DPEdgeMenu.svg)](https://github.com/HongliYu/DPEdgeMenu-Swift/blob/master/LICENSE)

![screenshot](https://github.com/HongliYu/DPEdgeMenu-Swift/blob/master/DPEdgeMenu.gif?raw=true)


# Usage

```  swift
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
```