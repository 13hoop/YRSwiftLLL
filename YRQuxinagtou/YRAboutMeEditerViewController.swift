//
//  YRAboutMeEditerViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/8.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

private let identifer: String = "aboutMeCell"
class YRAboutMeEditerViewController: UIViewController {

    var titleListArr: [String] = ["个人介绍", "婚恋状态", "性取向", "外贸", "居住情况", "子女情侣", "是否吸烟", "饮酒", "运动"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关于我"
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
        tableView.registerClass(AboutMeCell.self, forCellReuseIdentifier: identifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.rowHeight = 74.0;
        tableView.tableFooterView = UIView()
        return tableView
    }()
}


extension YRAboutMeEditerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleListArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifer) as! AboutMeCell
        cell.titleLb.text = titleListArr[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

private class AboutMeCell: UITableViewCell {
    
    let titleLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(14.0)
        return label
    }()

    let disLb: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexStringColor(hex: "#656565")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "未婚无伴侣"
        label.font = UIFont.systemFontOfSize(14.0)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews()  {
        accessoryType = .DisclosureIndicator
        contentView.addSubview(titleLb)
        contentView.addSubview(disLb)
        
        let viewsDict = ["disLb" : disLb,
                         "titleLb" : titleLb]
        let vflDict = ["H:|-15-[titleLb]-|",
                       "V:|-[titleLb]-[disLb]-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllLeading, metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
