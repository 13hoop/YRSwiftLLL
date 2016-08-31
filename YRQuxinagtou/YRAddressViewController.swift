//
//  YRAddressViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/18.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAddressViewController: UIViewController {
    
    private var addresses: AddressList? {
        didSet {
            if let list = addresses?.list {
                self.list = list
            }
        }
    }
    private var list:[Address] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(AddressCell.self, forCellReuseIdentifier: "AddressCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    private let nvgTipLb: UILabel = {
        let label = UILabel()
        label.text = "您的地址其他会员不可见，仅在寄送奖品或收取他人礼物时供发货系统使用"
        label.font = UIFont.systemFontOfSize(15.0)
        label.textColor = YRConfig.mainTextColored
        label.textAlignment = .Center
        label.numberOfLines = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "收货地址"
        view.backgroundColor = YRConfig.plainBackgroundColored
        let item = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(creatAddressAction))
        navigationItem.rightBarButtonItem = item
        fetchAddressData()
        setUpViews()
    }
    
    private func setUpViews() {
        view.addSubview(nvgTipLb)
        view.addSubview(tableView)

        let viewsDict = ["tableView" : tableView,
                         "nvgTipLb" :nvgTipLb ]
        let vflDict = ["H:|-0-[tableView]-0-|",
                       "V:|-[nvgTipLb(100)]-0-[tableView]-|",
                       "H:|-[nvgTipLb]-|" ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    private func fetchAddressData() {
        YRService.requiredAddress(success: { [weak self] (result) in
            if let data = result!["data"] as? [AnyObject] {
                self?.addresses = AddressList(fromJSONDictionary: data)
            }
        }, fail: { error in
                print("required address error:\(error)")
        })
    }
    
    //MARK: Action
    func creatAddressAction() {
        let vc = YRAddressCreatedViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension YRAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
        // return self.list.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell") as! AddressCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clearColor()
        return header
    }
}


private class AddressCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        
    }
    
    private func setUpViews() {
//        backgroundColor = YRConfig.plainBackgroundColored
        
        contentView.addSubview(nameLb)
        contentView.addSubview(phoneLb)
        contentView.addSubview(addressLb)
        contentView.addSubview(selectedBtn)
        contentView.addSubview(editBtn)
        contentView.addSubview(deleltBtn)
        
        let viewsDict = ["nameLb" : nameLb,
                         "phoneLb" : phoneLb,
                         "addressLb" : addressLb,
                         "selectedBtn" : selectedBtn,
                         "editBtn" : editBtn,
                         "deleltBtn" : deleltBtn]
        let vflDict = ["H:|-[nameLb(<=80)]-0-[phoneLb]-|",
                       "V:|-[nameLb]-[addressLb]-1-[selectedBtn(<=40)]-|",
                       "H:[addressLb]-|",
                       "H:[selectedBtn]-0-[editBtn(100)]-0-[deleltBtn(60)]-|"
        ]

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllLeading, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
    }
    
    
    let nameLb: UILabel = {
        let label = UILabel()
        label.text = "zhang三"
        label.shadowColor = YRConfig.mainTextColored
        label.shadowOffset = CGSizeMake(0, 1)
        label.numberOfLines = -1
        label.preferredMaxLayoutWidth = 180.0
        label.font = UIFont.systemFontOfSize(16.0)
        label.textAlignment = .Left
        label.backgroundColor = .whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let phoneLb: UILabel = {
        let label = UILabel()
        label.text = "1877777777"
        label.textAlignment = .Left
        label.backgroundColor = .whiteColor()
        label.font = UIFont.systemFontOfSize(16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let addressLb: UILabel = {
        let label = UILabel()
        label.text = "北京市昌平区对方感受到快乐附近孤苦伶仃附近孤苦伶仃房价"
        label.textAlignment = .Left
        label.numberOfLines = -1
        label.backgroundColor = .whiteColor()
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = YRConfig.mainTextColored
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgV1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let imgV2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let selectedBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        btn.setTitle("默认地址", forState: .Normal)
        btn.setTitle("默认地址", forState: .Highlighted)
        btn.setImage(UIImage(named: "like_slc")?.resizeWithWidth(40), forState: .Normal)
        btn.contentHorizontalAlignment = .Left
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
        btn.backgroundColor = .whiteColor()
        btn.setTitleColor(.blackColor(), forState: .Normal)
        btn.setTitleColor(.blackColor(), forState: .Highlighted)
        return btn
    }()
    let editBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        btn.backgroundColor = .whiteColor()
        btn.setTitle("编辑", forState: .Normal)
        btn.setTitle("编辑", forState: .Highlighted)
        btn.setTitleColor(YRConfig.mainTextColored, forState: .Normal)
        btn.setTitleColor(YRConfig.mainTextColored, forState: .Highlighted)
        return btn
    }()
    let deleltBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        btn.backgroundColor = .whiteColor()
        btn.setTitle("删除", forState: .Normal)
        btn.setTitle("删除", forState: .Highlighted)
        btn.setTitleColor(YRConfig.mainTextColored, forState: .Normal)
        btn.setTitleColor(YRConfig.mainTextColored, forState: .Highlighted)
        return btn
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//class RightButton: UIButton {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
