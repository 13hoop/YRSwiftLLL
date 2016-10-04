//
//  YRExt.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/3/5.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import CoreImage

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
        return hexStringColor(hex: hexString, alpha: 1.0)
    }
    
    static func hexStringColor(hex hexString: String,alpha alphaNum: CGFloat) -> UIColor? {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        guard NSScanner(string: hex).scanHexInt(&int) else {
            return nil
        }
        
        let r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha:  alphaNum)
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

extension NSDate {
    public static func coventeNowToDateStr() -> String {
        let date = NSDate()
        let fm = NSDateFormatter()
        fm.dateFromString("yyyy-MM-dd HH:mm:ss")
        let str = fm.stringFromDate(date)
        return str
    }

    public static func coventedIntToDateStr(intNum: Int64) -> String {
        let date = coventedIntToDate(intNum)
        let str = coventeDateToStr(date)
        return str
    }

    // int to date
    public static func coventedIntToDate(intNum: Int64) -> NSDate {
        let timeInreval = NSTimeInterval(intNum / 1000)
        let date = NSDate(timeIntervalSince1970: timeInreval)
        return date
    }
    
    // date to str
    public static func coventeDateToStr(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.dateFormat = "HH:mm"
        let str = formatter.stringFromDate(date)
        return str
    }
}

public enum FileExtension: String {
    
    case JPEG = "jpg"
    case M4A = "m4a"
    
    public var mimeType: String {
        switch self {
        case .JPEG:
            return "image/jpeg"
        case .M4A:
            return "audio/m4a"
        }
    }
}

extension NSFileManager {
    
    public class func yrCachesURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    }
    
    public class func yrMessageCachesURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        let messageCachesURL = yrCachesURL().URLByAppendingPathComponent("yr_message_caches", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(messageCachesURL!, withIntermediateDirectories: true, attributes: nil)
            return messageCachesURL
        } catch let error {
            print("message caches url error:\(error)")
        }
        return nil
    }
    
    public class func yrAudioMessageURLWithName(fileName: String) -> NSURL? {
        
        if let messageCachesURL = yrMessageCachesURL() {
            let url = messageCachesURL.URLByAppendingPathComponent("\(fileName).\(FileExtension.M4A.rawValue)")
            print(url)
            return url
        }
        return nil
    }

    public class func yrAudioMessageSaved(audioData: NSData, fileName: String) -> NSURL? {
        return nil
    }
}






