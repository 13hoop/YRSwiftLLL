//
//  YRSearchFilterViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/23.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRSearchFilterViewController: UIViewController {
    
    
    var filter: Filters? {
        didSet {
            if let gender = filter?.gender,
                let local = filter?.city {

                var sex = "默认"
                switch gender {
                case "1":
                    sex = "男"
                case "2":
                    sex = "女"
                default:
                    sex = "男，女都可以"
                }
                
                var age: String = "20-30岁"
                if let min = filter?.age_min,let max = filter?.age_max {
                    age = min + "-" + max + "岁"
                }
                
                defaultDetail = [local, age, sex]
                tableView.reloadData()
            }
        }
    }
    
    private var updateDetail: [String: String] = [:]
    private var defaultDetail = ["默认", "20-30岁", " 默认"]
    private let titleArr = ["地区", "年龄", "性别"]
    
    let address = ["北京","上海","浙江","海南","湖北","湖南","澳门","甘肃","福建","西藏","贵州","辽宁","重庆","陕西","青海","香港","河南","河北","江西","云南","内蒙古","台湾","吉林","四川","天津","宁夏","安徽","山东","山西","广东","广西","新疆","江苏","黑龙江","海外"]
    let male = ["男,女都可以", "女", "男"]

    private var minRow = 0
    private var selectedAgeMin = "18"
    private var selectedAgeMax = "58"
    private var selectedCellIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    
    lazy var titleLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.textAlignment = .Center
        view.text = "地 区"
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var picker: UIPickerView = {
        let view = UIPickerView(frame: CGRectZero)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        view.backgroundColor = YRConfig.plainBackgroundColored
        setUpViews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        print(self.updateDetail)
        
        if self.updateDetail.count > 0 {
            YRService.updateFilters(data: self.updateDetail, success: { (result) in
                
                print("  update filter  here   🎃  ")
                }, fail: { (error) in
                print(" update friends Filters error:\(error )")
            })
        }
    }
    
    private func loadData() {
        YRService.requiredOPFilters(success: { (result) in
            if let data = result!["data"] as? [String : AnyObject] {
                self.filter = Filters(fromJSONDictionary: data)
            }
        }, fail: { error in
            print("required Filters error: \(error)")
        })
    }
    
    private func setUpViews() {
        
        view.addSubview(tableView)
        view.addSubview(titleLb)
        view.addSubview(picker)
        
        let viewsDict = ["tableView" : tableView,
                            "picker" : picker,
                            "titleLb" : titleLb]
        let vflDict = ["H:|-0-[tableView]-0-|",
                       "V:|-[tableView]-|",
                       "H:|-0-[titleLb]-0-|",
                       "H:|-0-[picker]-0-|",
                       "V:[titleLb(44)]-1-[picker(200)]-|"]

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
    }
}

extension YRSearchFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = titleArr[indexPath.row]
        cell.detailTextLabel?.text = defaultDetail[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.titleLb.text = self.titleArr[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let lastCell = tableView.cellForRowAtIndexPath(self.selectedCellIndexPath)
        lastCell?.accessoryType = .None
        cell?.accessoryType = .Checkmark
        self.selectedCellIndexPath = indexPath
        self.picker.reloadAllComponents()
    }
}

extension YRSearchFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
        self.updateDetail = [
            "city" : (self.filter?.city)!,
            "age_min" : (self.filter?.age_min)!,
            "age_max" : (self.filter?.age_max)!,
            "gender" : (self.filter?.gender)!
         ]
        
        let cell = self.tableView.cellForRowAtIndexPath(selectedCellIndexPath)! as UITableViewCell
        switch selectedCellIndexPath.row {
        case 0:
            cell.detailTextLabel?.text = self.address[row]
            self.updateDetail.updateValue(self.address[row], forKey: "city")
        case 1:
            if component == 1 {
                self.selectedAgeMax = "\(minRow + row + 19)岁"
                self.updateDetail.updateValue("\(minRow + row + 19)", forKey: "age_max")
            }else {
                self.minRow = row
                self.selectedAgeMin = "\(row + 18)"
                self.updateDetail.updateValue("\(row + 18)", forKey: "age_min")
                self.picker.reloadComponent(1)
            }
            cell.detailTextLabel?.text = selectedAgeMin + " - " + selectedAgeMax
        case 2:
            cell.detailTextLabel?.text = self.male[row]
            self.updateDetail.updateValue("\(row)", forKey: "gender")
        default:
            print(#function)
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedCellIndexPath.row {
        case 0:
            return self.address[row]
        case 1:
            if component == 0 {
                return "\(row + 18) "
            }else {
                return "\(minRow + row + 19) 岁"
            }
        case 2:
            return self.male[row]
        default:
            return "-- --"
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch selectedCellIndexPath.row {
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedCellIndexPath.row {
        case 0:
            return self.address.count
        case 1:
            if component == 0 {
                return 40
            }else {
                return 40 - minRow
            }
        case 2:
            return self.male.count
        default:
            return 5
        }
    }
}
