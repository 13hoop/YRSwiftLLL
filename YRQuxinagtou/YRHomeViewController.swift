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
//        YRService.requireLogIn(success: { 
//            
//            print(" SMS data! ")
//            
//            }) {_ in 
//            
//            print("error here")
//        }
        
        YRService.requireLogIn(success: { 
            print(" SMS data! ")
            }) { error in
            print("error here: \(error)")
        }
        
        
//        YRService.requireSMSCode(success: { 
//            print("  success here! ")
//            }) { 
//            print(" ~ error here ~ ")
//        }
    }

    
}
