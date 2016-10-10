//
//  YRRegisterMaleViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/10.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRegisterMaleViewController: UIViewController {

    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var famaleBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        maleBtn.layer.cornerRadius = 5.0
        maleBtn.layer.masksToBounds = false
        famaleBtn.layer.cornerRadius = 5.0
        famaleBtn.layer.masksToBounds = false
    }

    @IBAction func sendMaleAction(sender: UIButton) {
        sender.backgroundColor = YRConfig.themeTintColored
        push()
    }
    @IBAction func sendFamaleAction(sender: UIButton) {
        sender.backgroundColor = YRConfig.themeTintColored
        push()
    }
    
    private func push() {
        let vc = YRFastOpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
