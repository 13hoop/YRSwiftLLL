//
//  YRRegisterViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/21.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRegisterViewController: UIViewController {

    let accountTF: UITextField = {
        let view = UITextField(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTF: UITextField = {
        let view = UITextField(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews() {

        
        
    }
}
