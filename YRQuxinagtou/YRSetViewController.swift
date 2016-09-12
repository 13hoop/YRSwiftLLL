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
    
}
