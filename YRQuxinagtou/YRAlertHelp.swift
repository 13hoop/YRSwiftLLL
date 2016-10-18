//
//  YRAlertHelp.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/16.
//  Copyright © 2016年 YongRen. All rights reserved.
//

/*
    集中处理：
        无法获得授权等的alert处理 － cannotAllowedToAccessXXX()
 */

import UIKit

struct YRAlertDisc {
    let title: String?
    let message: String?
    let confirmTitle: String?
    let cancleTitle: String?
}

class YRAlertHelp {
    
    class func confirmOrCancel(title title: String, message: String, confirmTitle: String, cancleTile: String, inViewController viewController: UIViewController?, withConfirmAction confirmAction: () -> Void, cancelAction: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) { 
            let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: cancleTile, style: .Cancel, handler: { (action) in
                cancelAction()
            })
            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .Default, handler: { (action) in
                confirmAction()
            })
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAutoAlert(time time: NSTimeInterval, title titleStr:String, message: String, inViewController viewController: UIViewController?, completion: (()-> Void)? = nil) {
        let alertController: UIAlertController = UIAlertController(title: titleStr, message: message, preferredStyle: .Alert)
        viewController?.presentViewController(alertController, animated: true, completion: {
            yr_Delay(time, task: {
                alertController.dismissViewControllerAnimated(true, completion: completion)
            })
        })
    }
    
    class func showAutoAlertCancel(title titleStr:String, message: String, cancelAction header: (UIAlertAction -> Void)?,inViewController viewController: UIViewController?, completion: (()-> Void)? = nil) {
        let alertController: UIAlertController = UIAlertController(title: titleStr, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "取消", style: .Cancel, handler: header)
        alertController.addAction(action)
        viewController?.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    // camera
    func cannotAllowedToAcessCamera() {
        dispatch_async(dispatch_get_main_queue()) {
            YRAlertHelp.confirmOrCancel(title: "抱歉", message: "未授权访问相机，请在设置中更改授权,", confirmTitle: "马上授权", cancleTile: "了解", inViewController: self, withConfirmAction: {
                
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)

                }, cancelAction: {
            })
        }
    }
    
    // cameraRoll
    func cannotAllowedToAcessCameraRoll() {
        dispatch_async(dispatch_get_main_queue()) {
            YRAlertHelp.confirmOrCancel(title: "抱歉", message: "未授权访问相册，请在设置中更改授权,", confirmTitle: "马上授权", cancleTile: "了解", inViewController: self, withConfirmAction: {
                
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                
                }, cancelAction: {
            })
        }
    }
    
    // micro
    func cannotAllowedToAcessMicro() {
        dispatch_async(dispatch_get_main_queue()) { 
            YRAlertHelp.confirmOrCancel(title: "抱歉", message: "未授权访问麦克风，请在设置中更改授权,", confirmTitle: "马上授权", cancleTile: "了解", inViewController: self, withConfirmAction: { 
                
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                
                }, cancelAction: {
            })
        }
    }
    
    // location
    
    
}
