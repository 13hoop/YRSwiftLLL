//
//  YROrderListViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YROrderListViewController: UIViewController {

//    var list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "账单"
        loadData()
        view.backgroundColor = YRConfig.themeTintColored
        setUpViews()
    }
    
    private func loadData() {
        YRService.requiredBillList(success: { [weak self](result) in
            if let data = result!["data"] {
                
            }
        }, fail: { error in
            print(" required bill list error: \(error)")
        })
    }

    private func setUpViews() {

        if let url = NSURL(string: YRUserDefaults.userAvatarURLStr) as NSURL? {
            UIImage.loadImageUsingKingfisher(url, completion: {[weak self] (image, error, cacheType, imageURL) in
                if let img = image {
                    self?.imgV.image = img
                }
            })
        }
        leftBtn.addTarget(self, action: #selector(purchedAction), forControlEvents: .TouchUpInside)
        rightBtn.addTarget(self, action: #selector(serveAction), forControlEvents: .TouchUpInside)
        nvgView.addSubview(imgV)
        nvgView.addSubview(restLb)
        nvgView.addSubview(leftBtn)
        nvgView.addSubview(rightBtn)
        view.addSubview(nvgView)
        tableView.rowHeight = 88.0
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        let viewsDict = ["tableView" : tableView,
                         "nvgView" : nvgView,
                         "imgV" : imgV,
                         "restLb" :restLb ,
                         "leftBtn" : leftBtn,
                         "rightBtn" : rightBtn]
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
        
        nvgView.addConstraint(NSLayoutConstraint(item: imgV, attribute: .CenterX, relatedBy: .Equal, toItem: nvgView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        nvgView.addConstraint(NSLayoutConstraint(item: imgV, attribute: .CenterY, relatedBy: .Equal, toItem: nvgView, attribute: .CenterY, multiplier: 1.0, constant: -30))
        nvgView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: .AlignAllCenterX, metrics: nil, views: viewsDict))
        nvgView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        nvgView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
        nvgView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[6] as String, options: [], metrics: nil, views: viewsDict))
        nvgView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[7] as String, options: [], metrics: nil, views: viewsDict))
        nvgView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[8] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    private let nvgView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 50.0
        imgV.layer.masksToBounds = true
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    private let restLb: UILabel = {
        let label = UILabel()
        label.text = "账户剩余: 9000 钻"
        label.font = UIFont.systemFontOfSize(15.0)
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let leftBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        btn.setTitle("充值", forState: .Normal)
        btn.setTitle("充值", forState: .Highlighted)
        btn.setTitleColor(.whiteColor(), forState: .Normal)
        btn.setTitleColor(.whiteColor(), forState: .Highlighted)
        return btn
    }()
    private let rightBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        btn.setTitle("客服", forState: .Normal)
        btn.setTitle("客服", forState: .Highlighted)
        btn.setTitleColor(.whiteColor(), forState: .Normal)
        btn.setTitleColor(.whiteColor(), forState: .Highlighted)
        return btn
    }()

    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(OrderCell.self, forCellReuseIdentifier: "OrderCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    //MARK: Action
    func purchedAction() {
        print(#function)
    }
    func serveAction() {
        print(#function)
    }
}

extension YROrderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell") as! OrderCell
        return cell
    }
}

class OrderCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(nameLb)
        contentView.addSubview(timeLb)
        contentView.addSubview(priceLb)

        let viewsDict = ["nameLb" : nameLb,
                         "timeLb" : timeLb,
                         "priceLb" : priceLb]
        let vflDict = ["H:|-[nameLb]",
                       "V:|-20-[priceLb]-[timeLb]",
                       "H:[priceLb]-|"
                       ]
        contentView.addConstraint(NSLayoutConstraint(item: nameLb, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllTrailing, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    

    let nameLb: UILabel = {
        let label = UILabel()
        label.text = "充值在“找朋友”中推广自己"
        label.numberOfLines = -1
        label.preferredMaxLayoutWidth = 180.0
        label.font = UIFont.systemFontOfSize(16.0)
        label.textAlignment = .Left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let timeLb: UILabel = {
        let label = UILabel()
        label.text = "2016-06-01 15:50"
        label.textAlignment = .Right
        label.textColor = YRConfig.mainTextColored
        label.font = UIFont.systemFontOfSize(14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLb: UILabel = {
        let label = UILabel()
        label.text = "＋1000 钻"
        label.textAlignment = .Right
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = YRConfig.themeTintColored
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
