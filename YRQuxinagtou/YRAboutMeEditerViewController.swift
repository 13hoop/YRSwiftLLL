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


    var editPageArr: [String?]? {
        didSet {
            print(editPageArr)
        }
    }
    
    var isUpdated: Bool = false
    var updateList: [String: AnyObject] = [:]
    
    typealias action = (text: String, index: Int) -> Void
    var callBack: action?
    
    let titleListArr: [String] = ["个人介绍", "出生地", "民族", "婚恋状态", "身高", "体型", "职业", "年收入", "居住情况", "子女情侣", "吸烟", "饮酒", "运动"]
    let titleKeys:[String] = ["relationship", "height", "body_type", "industry", "annual_income", "living", "kids", "smoking", "drinking", "exercise"]
    let metaArr: [String: AnyObject] = [
        "relationship": ["用户未选择", "未婚无伴侣", "未婚有伴侣", "已婚", "离异", "丧偶"],
        "nation": ["用户未选择", "用户未选择", "用户未选择", "用户未选择",],
        "birthplace": ["01", "02", "03", "04", "05"],
        "height": ["用户未选择", "用户未选择", "用户未选择", "用户未选择",],
        "industry": ["用户未选择", "互联网/游戏/软件", "电子/通信/硬件", "房地产/建筑/物业", "金融", "消费品", "汽车/机械/制造", "服务/外包/中介", "广告/传媒/教育/文化", "交通/贸易/物流", "制药/医疗", "能源/化工/环", "政府/农林牧渔"],
        "body_type": ["用户未选择", "丰满 (仅女性)", "高挑 (仅女性)", "肌肉男 (仅男性)", "强壮 (仅男性)", "匀称", "穿衣显瘦脱衣有肉", "偏瘦", "柔软的胖子"],
        "annual_income": ["用户未选择", "5万以下", "5~10万", "10~20万", "20~50万", "50~100万", "100万以上"],
        "living": ["用户未选择", "一个人住", "和伴侣住", "住在宿舍", "合租", "和父母住"],
        "kids": ["用户未选择", "没有，将来也不想要", "将来会有", "已有孩子", "孩子已独立"],
        "smoking": ["用户未选择", "从不", "偶尔", "看应酬需要", "每天"],
        "drinking": ["用户未选择", "从不", "偶尔", "看应酬需要", "喜欢"],
        "exercise": ["用户未选择", "从不运动", "偶尔运动", "规律性运动", "每天都运动"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关于我"
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        let item: UIBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(saveItemBtnClicked))
        navigationItem.rightBarButtonItem =  item

        setUpViews()
    }
    
    func saveItemBtnClicked() {
        print(#function)
        if isUpdated {
            print(self.updateList)
            YRService.updateProfile(params: self.updateList, success: { (result) in
                
                }, fail: { (error) in

                    print("update profile error here: \(error)")
            })
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(YRBioEditViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(YRBioEditViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(YRBioEditViewController(), animated: true)
        default:
            let current = self.editPageArr![indexPath.row - 3]!
            let index = Int(current)!
            let key = self.titleKeys[indexPath.row - 3]
            let listArr = self.metaArr[key] as! [String]
            
            let vc = YREditMoreViewController()
            vc.modelArr = listArr
            let defaultSelect = NSIndexPath(forRow: index, inSection: 0)
            vc.selectedIndex = defaultSelect
            
            vc.callBack = {[weak self] (text: String, selectedIndex: NSIndexPath) in
                let cell = self!.tableView.cellForRowAtIndexPath(indexPath) as! AboutMeCell
                cell.disLb.text = text
                
                
                print("defult: \(defaultSelect.row)  -- newSelected: \(selectedIndex.row)")
                
                if  selectedIndex.row != defaultSelect.row {
                    // updateList
                    print("--- ---   👹👹👹 updated --- ---")
                    self?.updateList[key] = "\(selectedIndex.row)"
                    self?.isUpdated = true
                }
                
                self?.callBack!(text: text, index: indexPath.row)

            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleListArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifer) as! AboutMeCell
        
        if indexPath.row != 2 && indexPath.row != 1 && indexPath.row != 0{
            let current = self.editPageArr![indexPath.row - 3]!
            let index = Int(current)!
            let key = self.titleKeys[indexPath.row - 3]
            let listArr = self.metaArr[key] as! [String]

            print(index)
            
            cell.titleLb.text = titleListArr[indexPath.row]
            cell.disLb.text = listArr[index]
            
        }else {
            cell.titleLb.text = titleListArr[indexPath.row]
            cell.disLb.text = self.editPageArr![indexPath.row]
        }
        return cell
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
        label.textColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
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
