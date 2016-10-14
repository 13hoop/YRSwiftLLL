//
//  YRSetViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/13.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRSetViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        title = "设置"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                print("notifiedpage setting here")
            } else {
                // change password
                let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("YRChangePasswordViewController") as! YRChangePasswordViewController
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            switch indexPath.row {
            case 1:
                // phone here
                dialPhone()
            case 2:
                let vc = YRBioEditViewController()
                vc.isCallBack = true
                navigationController?.pushViewController(vc
                    , animated: true)
            case 0:
                // help vc
                print(" show helpVC here!")
            default:
                return
            }
        }
    }
    
    // action 
    private func dialPhone() {
        let phoneNumStr = "18788888888"
        let webView = UIWebView()
        let url = NSURL(string: "tel://" + phoneNumStr)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        self.tableView.addSubview(webView)
    }
}
