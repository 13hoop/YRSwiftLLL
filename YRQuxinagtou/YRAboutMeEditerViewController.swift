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

    var defaultBio: String?
    var defaultBirthplace: String?
    var defaultNation: String?
    var defaultHeight: String?
    
    var editPageArr: [String?]?
    
    var isUpdated: Bool = false
    var isSaved: Bool = false
    var updateList: [String: AnyObject] = [:]
    
    var frontVC: YRProfileInfoViewController?
    
    typealias action = (isUpdate: Bool) -> Void
    var callBack: action?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(AboutMeCell.self, forCellReuseIdentifier: identifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.rowHeight = 74.0;
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
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
    
    // updateProflie
    private func updateProfile() {
        YRService.updateProfile(params: self.updateList, success: { [weak self](result) in
            
                self?.callBack!(isUpdate: true)
            
            }, fail: { (error) in
                print("update profile error here: \(error)")
        })
    }
}


extension YRAboutMeEditerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            
            let vc = YRBioEditViewController()
            vc.defaultBio = self.defaultBio
            vc.callBack = {[weak self] text in
                let cell = self!.tableView.cellForRowAtIndexPath(indexPath) as! AboutMeCell
                
                
                if  text != self?.defaultBio {
                    cell.disLb.text = text
                    self?.updateList["bio"] = "\(text)"
                    self?.isUpdated = true
                    self?.updateProfile()
                }else {
                    self?.isUpdated = false
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            
            let vc = YREditMoreViewController()
            vc.modelArr = ["北京","上海","浙江","海南","湖北","湖南","澳门","甘肃","福建","西藏","贵州","辽宁","重庆","陕西","青海","香港","河南","河北","江西","云南","内蒙古","台湾","吉林","四川","天津","宁夏","安徽","山东","山西","广东","广西","新疆","江苏","黑龙江","海外"]
            vc.callBack = {[weak self] (text: String?, selectedIndex: NSIndexPath) in
                let cell = self!.tableView.cellForRowAtIndexPath(indexPath) as! AboutMeCell
                cell.disLb.text = text
                if  text != self?.defaultBirthplace {
                    self?.updateList["birthplace"] = text
                    self?.isUpdated = true
                    self?.updateProfile()
                }else {
                    self?.isUpdated = false
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = YREditMoreViewController()
            vc.modelArr = ["汉族","黎族","纳西族","白族","畲族","瑶族","珞巴族","独龙族","满族","水族","毛南族","柯尔克孜族","朝鲜族","维吾尔族","羌族","高山族","阿昌族","门巴族","锡伯族","鄂温克族","鄂伦春族","达斡尔族","赫哲族","裕固族","藏族","蒙古族","苗族","景颇族","普米族","哈萨克族","哈尼族","僳僳族","傣族","保安族","俄罗斯族","侗族","佤族","仫佬族","仡佬族","京族","乌孜别克族","回族","土家族","撒拉族","拉祜族","怒族","德昂族","彝族","布朗族","布依族","壮族","塔塔尔族","塔吉克族","基诺族","土族","东乡族"]
            vc.callBack = {[weak self] (text: String?, selectedIndex: NSIndexPath) in
                let cell = self!.tableView.cellForRowAtIndexPath(indexPath) as! AboutMeCell
                cell.disLb.text = text
                if  text != self?.defaultNation {
                    self?.updateList["nation"] = text
                    self?.isUpdated = true
                    self?.updateProfile()
                }else {
                    self?.isUpdated = false
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = YREditMoreViewController()
            vc.isUserHeight = true
            vc.callBack = {[weak self] (text: String?, selectedIndex: NSIndexPath) in
                let cell = self!.tableView.cellForRowAtIndexPath(indexPath) as! AboutMeCell
                cell.disLb.text = text
                if  text != self?.defaultHeight {
                    self?.updateList["height"] = text
                    self?.isUpdated = true
                    self?.updateProfile()
                }else {
                    self?.isUpdated = false
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let current = self.editPageArr![indexPath.row - 3]!
            let index = Int(current)!
            let listArr = YREidtMe.transIndexToArr(indexPath.row - 3)
            let vc = YREditMoreViewController()
            vc.modelArr = listArr
            let defaultSelect = NSIndexPath(forRow: index, inSection: 0)
            vc.selectedIndex = defaultSelect
            
            // isUpdated?
            vc.callBack = {[weak self] (text: String?, selectedIndex: NSIndexPath) in
                let cell = self!.tableView.cellForRowAtIndexPath(indexPath) as! AboutMeCell
                cell.disLb.text = text
                if  selectedIndex.row != defaultSelect.row {
                    let key = YREidtMe.keyAtIndex(at: indexPath.row - 3)
                    print("--- ---   👹👹👹 updated  \(index) --- \(key)---")
                    self?.updateList[key] = "\(selectedIndex.row)"
                    self?.isUpdated = true
                    // updateProfile
                    self?.updateProfile()
                }else {
                        self?.isUpdated = false
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YREidtMe.titleListArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(identifer) as! AboutMeCell
        cell.titleLb.text = YREidtMe.titleAtIndex(at: indexPath.row)

        switch indexPath.row {
        case 0:
            cell.disLb.text = self.defaultBio
        case 1:
            cell.disLb.text = self.defaultBirthplace
        case 2:
            cell.disLb.text = self.defaultNation
        case 4:
            cell.disLb.text = self.defaultHeight
        default:
            // tableView's index and editPageArr's index
            let current = self.editPageArr![indexPath.row - 3]!
            let index = Int(current)!
            let listArr = YREidtMe.transIndexToArr(indexPath.row - 3)
            cell.disLb.text = listArr[index]
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
                       "H:[disLb]-|",
                       "V:|-[titleLb]-[disLb]-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllLeading, metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
