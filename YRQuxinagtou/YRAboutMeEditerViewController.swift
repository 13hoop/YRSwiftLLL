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
            self.navigationController?.pushViewController(YRBioEditViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(YRBioEditViewController(), animated: true)
        default:
            let current = self.editPageArr![indexPath.row - 3]!
            let index = Int(current)!
            
            let listArr = YREidtMe.transIndexToArr(indexPath.row - 3)
            
            let vc = YREditMoreViewController()
            vc.isUserHeight = indexPath.row == 4
            vc.modelArr = listArr
            let defaultSelect = NSIndexPath(forRow: index, inSection: 0)
            vc.selectedIndex = defaultSelect
            
            // isUpdated?
            vc.callBack = {[weak self] (text: String, selectedIndex: NSIndexPath) in
                let cell = self!.tableView.cellForRowAtIndexPath(indexPath) as! AboutMeCell
                cell.disLb.text = text
                
                if  selectedIndex.row != defaultSelect.row {
                    let key = YREidtMe.keyAtIndex(at: indexPath.row - 3)
                    print("--- ---   👹👹👹 updated  \(index) --- \(key)---")
                    self?.updateList[key] = indexPath.row == 4 ? text : "\(selectedIndex.row)"
                    
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
            cell.disLb.text = "bio"
        case 2:
            cell.disLb.text = "bio"
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
