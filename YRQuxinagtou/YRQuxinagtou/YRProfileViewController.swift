//
//  YRProfileViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        let item: UIBarButtonItem = UIBarButtonItem(title: "设置", style: .Plain, target: self, action: #selector(settingBtnClicked))
        navigationItem.rightBarButtonItem = item
    }

    func settingBtnClicked() {
        print(#function)
    }
}
