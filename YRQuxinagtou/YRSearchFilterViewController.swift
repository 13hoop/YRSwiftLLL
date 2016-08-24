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
                let sex = gender == "1" ? "男" : "女"
                
                var age: String = "20-30岁"
                if let min = filter?.age_min,let max = filter?.age_max {
                    age = min + "-" + max + "岁"
                }
                
                defaultDetail = [local, age, sex]
                tableView.reloadData()
            }
        }
    }
    
    var defaultDetail = ["默认", "20-30岁", " 默认"]
    private let titleArr = ["地区", "年龄", "性别"]
    
    let address = ["北京", "河北", "陕西" , "山东"]
    let male = ["女", "男"]

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
    
    private func loadData() {
        YRService.requiredFilters(success: { (result) in
           
            print(result)
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
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        let lastCell = tableView.cellForRowAtIndexPath(self.selectedCellIndexPath)
//        lastCell?.accessoryType = .None
//        cell?.accessoryType = .Checkmark
        
        self.selectedCellIndexPath = indexPath
        self.picker.reloadAllComponents()
    }
}

extension YRSearchFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let cell = self.tableView.cellForRowAtIndexPath(selectedCellIndexPath)! as UITableViewCell
        switch selectedCellIndexPath.row {
        case 0:
            print("address : ")
            cell.detailTextLabel?.text = "bbbb"
            
        case 1:
            if component == 1 {
                self.selectedAgeMax = "\(row + 18)岁"
            }else {
                self.selectedAgeMin = "\(row + 18)"
            }
            cell.detailTextLabel?.text = selectedAgeMin + " - " + selectedAgeMax
        case 2:
            cell.detailTextLabel?.text = self.male[row]
        default:
            print(#function)
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedCellIndexPath.row {
        case 0:
            return "beijing"
        case 1:
            if component == 0 {
                return "\(row + 18) "
            }else {
                return "\(row + 18) 岁"
            }
        case 2:
            return self.male[row]
        default:
            return "-- --"
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch selectedCellIndexPath.row {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedCellIndexPath.row {
        case 0:
            return self.address.count
        case 1:
            return 40
        case 2:
            return 2
        default:
            return 5
        }
    }
}