
//
//  YRBlackListViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/8.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

private let identifer: String = "backListCell"
private let headerIdentifer: String = "blackHeader"

class YRBlackListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "黑名单"
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        setUpViews()
    }

    private func setUpViews() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        let viewsDict = ["tableView" : tableView]
        let vflDict = ["H:|-0-[tableView]-0-|",
                       "V:|-[tableView]-|"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(BlackListCell.self, forCellReuseIdentifier: identifer)
        tableView.registerClass(BlackHeader.self, forHeaderFooterViewReuseIdentifier: headerIdentifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.rowHeight = 74.0;
        tableView.tableFooterView = UIView()
        return tableView
    }()

}


extension YRBlackListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifer) as! BlackListCell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerIdentifer)
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}

private class BlackListCell: UITableViewCell {
    
    let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    let nameLb: UILabel = {
        let label = UILabel()
        label.text = "Kobe"
        label.font = UIFont.systemFontOfSize(14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLb: UILabel = {
        let label = UILabel()
        label.text = "拉黑时间 2016-05-24"
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews()  {
        contentView.addSubview(imgV)
        contentView.addSubview(nameLb)
        contentView.addSubview(timeLb)
        
        let viewsDict = ["imgV" : imgV,
                         "nameLb" : nameLb,
                         "timeLb" : timeLb]
        let vflDict = ["H:|-15-[imgV(70)]-[nameLb]-|",
                       "V:|-0-[imgV]-0-|",
                       "V:|-[nameLb]-[timeLb]-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllLeading, metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class BlackHeader: UITableViewHeaderFooterView {
    
    let showSwitch: UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    let nameLb: UILabel = {
        let label = UILabel()
        label.text = "屏蔽通讯录联系人"
        label.font = UIFont.systemFontOfSize(15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let disLb: UILabel = {
        let label = UILabel()
        label.text = "在速配/找朋友中不会遇到通讯录里的联系人"
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews()  {
        
        backgroundColor = .whiteColor()
        addSubview(showSwitch)
        addSubview(nameLb)
        addSubview(disLb)
        
        let viewsDict = ["showSwitch" : showSwitch,
                         "nameLb" : nameLb,
                         "disLb" : disLb,
                         "superView": self]
        let vflDict = ["H:|-15-[nameLb]-[showSwitch]-|",
                       "V:|-15-[showSwitch]",
                       "V:|-[nameLb]-[disLb]"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllLeading, metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

