//
//  YRAdvertiseViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAdvertiseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "推广功能"
        navigationController?.navigationBarHidden = true
    }
    @IBAction func closeBtnAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
