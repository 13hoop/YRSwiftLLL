//
//  YRAdvertiseEachOneceViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAdvertiseEachOneceViewController: UIViewController {

    @IBOutlet weak var remainedLb: UILabel!
    @IBOutlet weak var setedMoneyLb: UILabel!
    @IBOutlet weak var changedBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    private var num: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    @IBAction func lessBtnAction(sender: UIButton) {
        guard num > 1 else { return }
        num -= 1
        setedMoneyLb.text = String(num)
    }
    @IBAction func addBtnAction(sender: UIButton) {
        num += 1
        setedMoneyLb.text = String(num)
    }
    
    @IBAction func changedBtnAction(sender: UIButton) {
        let vc = YRPurchedViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func nextBtnAction(sender: UIButton) {
        
        guard num > 0 else {
            sender.backgroundColor = YRConfig.disabledColored
            return
        }
        
        let vc = UIStoryboard(name: "MarketAndBadge", bundle: nil).instantiateViewControllerWithIdentifier("YRAdvertiseTotalCostViewController") as! YRAdvertiseTotalCostViewController
        vc.price = num
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func closeBtnAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
