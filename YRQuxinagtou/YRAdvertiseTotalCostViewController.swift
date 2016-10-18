//
//  YRAdvertiseTotalCostViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAdvertiseTotalCostViewController: UIViewController {

    var price: Int?
    
    @IBOutlet weak var chargedBtn: UIButton!
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var remainedMoneyLb: UILabel!
    @IBOutlet weak var beginAdverBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
        view.addGestureRecognizer(tap)
        
        moneyTF.addTarget(self, action: #selector(self.valueDidChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBarHidden = false
    }

    func tapAction() {
        view.endEditing(true)
    }
    
    func valueDidChanged() {
        beginAdverBtn.backgroundColor = YRConfig.themeTintColored
    }
    
    @IBAction func changedBtnAction(sender: AnyObject) {
        let vc = YRPurchedViewController()
        vc.navigationController?.navigationBarHidden = false
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func goAdvertisedBtnAction(sender: AnyObject) {
        guard moneyTF.text?.characters.count > 0 else {
            YRAlertHelp.showAutoAlert(time: 1, title: "警告", message: "必须输入有效趣币数名，如果不够请点击充值", inViewController: self)
            return
        }
        
        if let budget = moneyTF.text {
            
            let priceDict = ["price" : String(price),
                             "budget" : budget]
            
            YRProgressHUD.showActivityIndicator()
            YRService.openAdvertised(price: priceDict, success: { (rusult) in
                YRProgressHUD.hideActivityIndicator()

                // TODO: if success, go to "推广设置页" here
//                let vc = YRAdvertisedSettingViewController()
//                navigationController?.pushViewController(vc, animated: true)

            }, fail: { error in
                YRProgressHUD.hideActivityIndicator()
                    
            })
        }
    }
    
    @IBAction func closeBtnAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
