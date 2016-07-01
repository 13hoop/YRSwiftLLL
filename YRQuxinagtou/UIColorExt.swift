//
//  UIColorExt.swift
//  YRXiaChuFangDemo
//
//  Created by YongRen on 16/4/18.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func randomColor() -> UIColor {
        // 0.. 1 的随机数
        let r = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let g = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let b = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        return randomColor
    }
}