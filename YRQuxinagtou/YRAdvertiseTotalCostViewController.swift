//
//  YRAdvertiseTotalCostViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAdvertiseTotalCostViewController: UIViewController {

    @IBOutlet weak var chargedBtn: UIButton!
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var remainedMoneyLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
        view.addGestureRecognizer(tap)
    }

    func tapAction() {
        view.endEditing(true)
    }
    
    @IBAction func changedBtnAction(sender: AnyObject) {
    
    }

    @IBAction func goAdvertisedBtnAction(sender: AnyObject) {
    
    }
    
    @IBAction func closeBtnAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
