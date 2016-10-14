//
//  YRAboutUsViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAboutUsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            print(" show rate page here ")
        default:
            print(" 展示用户协议界面 here ")
        }
    }
}
