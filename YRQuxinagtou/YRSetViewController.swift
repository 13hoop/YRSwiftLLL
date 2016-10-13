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
            print(" secton 1 be selected ")
        }
    }
    
}
