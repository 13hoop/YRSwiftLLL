//
//  YRRegisterMaleViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/10.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRRegisterMaleViewController: UIViewController {

    @IBOutlet weak var errorLb: UILabel!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var famaleBtn: UIButton!
    private var selectedMale: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage.pureColor(UIColor.whiteColor()), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = YRConfig.systemTintColored

        errorLb.text = ""
        maleBtn.layer.cornerRadius = 5.0
        maleBtn.layer.masksToBounds = false
        famaleBtn.layer.cornerRadius = 5.0
        famaleBtn.layer.masksToBounds = false
    }

    @IBAction func sendMaleAction(sender: UIButton) {
        sender.backgroundColor = YRConfig.themeTintColored
        selectedMale = "1"
        push()
    }
    @IBAction func sendFamaleAction(sender: UIButton) {
        sender.backgroundColor = YRConfig.themeTintColored
        selectedMale = "2"
        push()
    }
    
    private func push() {
        guard selectedMale != "" else {
            errorLb.text = "请选择性别"
            return
        }
        YRUserDefaults.gender = selectedMale
        let vc = YRFastOpViewController()
        vc.showNextBtn = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
