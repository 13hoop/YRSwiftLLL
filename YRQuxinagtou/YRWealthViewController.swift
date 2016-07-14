//
//  YRWealthViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/6.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRWealthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        title = "资产"
        setUpViews()
    }
    
    private func setUpViews() {
        
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}
