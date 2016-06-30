//
//  YRHomeViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRHomeViewController: UIViewController {


    let photoArr = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        loadData()
    }
    
    private func setUpViews() {
        
        view.backgroundColor = UIColor.randomColor()
    }
    
    private func loadData() {
        YRService.requireSMSCode(success: {
            print(" SMS data! ")
            }) { 
            print("error here")
        }
    }

    
}
