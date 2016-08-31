//
//  YRAddressViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/18.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAddressViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(AddressCell.self, forCellReuseIdentifier: "AddressCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    private let nvgView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nvgTipLb: UILabel = {
        let label = UILabel()
        label.text = "您的地址其他会员不可见，仅在寄送奖品或收取他人礼物时供发货系统使用"
        label.font = UIFont.systemFontOfSize(15.0)
        label.textColor = YRConfig.mainTextColored
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YRConfig.plainBackgroundColored

        let item = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(creatAddressAction))
        navigationItem.rightBarButtonItem = item
        
        fetchAddressData()
        setUpViews()
    }
    
    private func setUpViews() {
        
        nvgView.addSubview(nvgTipLb)
        view.addSubview(nvgView)
        tableView.rowHeight = 178.0
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        let viewsDict = ["tableView" : tableView,
                         "nvgView" : nvgTipLb,
                         "nvgTipLb" :nvgTipLb ]
        let vflDict = ["H:|-0-[tableView]-0-|",
                       "V:|-[nvgView(200)]-0-[tableView]-|",
                       "H:|-0-[nvgView]-0-|",
                       "V:[imgV(100)]-[restLb]",
                       "H:[imgV(100)]",
                       "H:|-[leftBtn]",
                       "V:[leftBtn]-|",
                       "H:[rightBtn]-|",
                       "V:[rightBtn]-|",
                       ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        
    }
 
    private func fetchAddressData() {
//        YRService.requiredAddressData(success: { result in
//            if let data = result!["data"] {
//                if let all_province_city = data["all_province_city"] {
//                    self.all_province_city = all_province_city as! [String : AnyObject]
//                    print(self.all_province_city)
//                }
//            }
//            
//            }, fail: { error in
//                print("required address data error:\(error)")
//        })
    }
    
    //MARK: Action
    func creatAddressAction() {
        let vc = YRAddressCreatedViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension YRAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell") as! AddressCell
        return cell
    }
}


private class AddressCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(nameLb)
        contentView.addSubview(phoneLb)
        contentView.addSubview(addressLb)
        contentView.addSubview(selectedBtn)
        contentView.addSubview(editBtn)
        contentView.addSubview(deleltBtn)
        
//        let viewsDict = ["nameLb" : nameLb,
//                         "phoneLb" : phoneLb,
//                         "addressLb" : addressLb,
//                         "selectedBtn" : selectedBtn,
//                         "editBtn" : editBtn,
//                         "deleltBtn" : deleltBtn]
//        let vflDict = ["H:|-[nameLb]",
//                       "V:|-20-[priceLb]-[timeLb]",
//                       "H:[priceLb]-|"
//        ]
//        contentView.addConstraint(NSLayoutConstraint(item: nameLb, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllTrailing, metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    
    let nameLb: UILabel = {
        let label = UILabel()
        label.text = "zhang三"
        label.numberOfLines = -1
        label.preferredMaxLayoutWidth = 180.0
        label.font = UIFont.systemFontOfSize(16.0)
        label.textAlignment = .Left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneLb: UILabel = {
        let label = UILabel()
        label.text = "1877777777"
        label.textAlignment = .Right
        label.textColor = YRConfig.mainTextColored
        label.font = UIFont.systemFontOfSize(14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLb: UILabel = {
        let label = UILabel()
        label.text = "＋1000 钻"
        label.textAlignment = .Right
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = YRConfig.themeTintColored
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectedBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        btn.setTitle("默认地址", forState: .Normal)
        btn.setTitle("默认地址", forState: .Highlighted)
        btn.setTitleColor(.whiteColor(), forState: .Normal)
        btn.setTitleColor(.whiteColor(), forState: .Highlighted)
        return btn
    }()
    let editBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        btn.setTitle("编辑", forState: .Normal)
        btn.setTitle("编辑", forState: .Highlighted)
        btn.setTitleColor(.whiteColor(), forState: .Normal)
        btn.setTitleColor(.whiteColor(), forState: .Highlighted)
        return btn
    }()
    let deleltBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        btn.setTitle("删除", forState: .Normal)
        btn.setTitle("删除", forState: .Highlighted)
        btn.setTitleColor(.whiteColor(), forState: .Normal)
        btn.setTitleColor(.whiteColor(), forState: .Highlighted)
        return btn
    }()

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
