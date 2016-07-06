//
//  YRExt.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/3/5.
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
    
    static func hexColor(hex value: UInt32) -> UIColor {
        let r = CGFloat((value & 0xFF0000) >> 16 ) / 256.0
        let g = CGFloat((value & 0xFF00) >> 16 ) / 256.0
        let b = CGFloat((value & 0xFF) >> 16 ) / 256.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static func hexStringColor(hex hexString: String) -> UIColor? {
        
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        guard NSScanner(string: hex).scanHexInt(&int) else {
            return nil
        }
        
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }

    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.max, height: height)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }

    func stringConstrainedSize(font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: CGFloat.max, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
        return boundingBox
    }
}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.max, height: height)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}

extension UIFont {
    func sizeOfString (string: NSString, constrainedToWidth width: Double) -> CGSize {
        return string.boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
                                           options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                           attributes: [NSFontAttributeName: self],
                                           context: nil).size
    }
}