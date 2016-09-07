//
//  YRAddressCreatedViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/30.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAddressCreatedViewController: UIViewController {

    private let titles = ["收货人", "电话", "所在地区", "详细地址"]
//    var defaultInfo: [String: AnyObject] = [:]
    var updateInfo: [String: AnyObject] = [:]
    
    private var textDict:[String: String] = [:]
    private var seletcedIndex: NSIndexPath?
    private var heightContraint: NSLayoutConstraint?
    
    private lazy var addressCell: AddressCreatedCell = AddressCreatedCell()
    private lazy var phoneCell: AddressCreatedCell = AddressCreatedCell()
    private lazy var nameCell: AddressCreatedCell = AddressCreatedCell()
    private lazy var detailCell: AddressCreatedCell = AddressCreatedCell()

    lazy var addressPicker: UIPickerView = {
        let view = UIPickerView(frame: CGRectZero)
        view.dataSource = self
        view.backgroundColor = .whiteColor()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(AddressCreatedCell.self, forCellReuseIdentifier: "AddressCreatedCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsetsMake(8, 8, 8, 8)
        tableView.separatorColor = YRConfig.plainBackgroundColored
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var all_province = []
    private var all_province_city : [String: AnyObject] = [:]
    private var all_city_district : [String: AnyObject] = [:]
    
    private var citysInProvice = []
    private var zoneIncity = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = YRConfig.plainBackgroundColored
        fetchAddressData()
        setUpViews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        creatAddress()
    }
    
    private func setUpViews() {
        view.addSubview(tableView)
        view.addSubview(addressPicker)
        
        let viewsDict = ["addressPicker" : addressPicker,
                         "tableView" : tableView]
        let vflDict = ["H:|-0-[addressPicker]-0-|",
                       "H:|-0-[tableView]-0-|",
                       "V:|-[tableView]-[addressPicker]-|"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        self.heightContraint = NSLayoutConstraint(item: addressPicker, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 0)
        view.addConstraint(heightContraint!)
    }
    
    private func fetchAddressData() {
        YRService.requiredreginAddress(success: { result in
            if let data = result!["data"] {
                if let all_province_city = data["all_province"] as? [AnyObject]  {
                    self.all_province = all_province_city
                }
                
                if let all_province_city = data["all_province_city"] as? [String : AnyObject] {
                    self.all_province_city = all_province_city
                }
                
                if let all_city_district = data["all_city_district"] as? [String : AnyObject] {
                    self.all_city_district = all_city_district
                }
            }
            
            self.addressPicker.reloadAllComponents()
            self.addressPicker.selectRow(0, inComponent: 0, animated: false)
            
            }, fail: { error in
                print("required address data error:\(error)")
        })
    }
    
    private func creatAddress() {
        
        self.updateInfo["consignee"] = self.nameCell.textFiled.text
        self.updateInfo["mobile"] = self.phoneCell.textFiled.text
        self.updateInfo["detailed"] = self.detailCell.textFiled.text
        
        YRService.creatAddress(address: self.updateInfo, success: {(result) in
            print(result)
            }, fail: {error in
            print("creat new address error: \(error)")
        })
    }
}

extension YRAddressCreatedViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.all_province.count
        case 1:
            return self.citysInProvice.count
        case 2:
            return self.zoneIncity.count
        default:
            return 1
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            let obj = self.all_province[row] as! [String : String]
            let title = obj["name"]
            return title
        case 1:
            let obj = self.citysInProvice[row] as! [String : String]
            let title = obj["name"]
            return title
        case 2:
            let obj = self.zoneIncity[row] as! [String : String]
            let title = obj["name"]
            return title
        default:
            let title = "－－"
            return title
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            // 安徽
            let obj = self.all_province[row] as! [String : String]
            let title = obj["name"]
            let id = obj["id"]
            self.updateInfo["province_id"] = id
            self.textDict["province"] = title!
            self.addressCell.textFiled.text = title!

            // [合肥， 宿州 ...]
            self.citysInProvice = self.all_province_city[id!] as! [AnyObject]
            self.addressPicker.reloadComponent(1)
        case 1:
            let obj = self.citysInProvice[row] as! [String : String]
            let title = obj["name"]
            let id = obj["id"]
            self.updateInfo["city_id"] = id
            self.textDict["city"] = title!
            self.addressCell.textFiled.text = self.textDict["province"]! + title!
            
            self.zoneIncity = self.all_city_district[id!] as! [AnyObject]
            self.addressPicker.reloadComponent(2)
        case 2:
            let obj = self.zoneIncity[row] as! [String : String]
            let title = obj["name"]
            let id = obj["id"]
            self.updateInfo["district_id"] = id
            self.textDict["zone"] = title!
            self.addressCell.textFiled.text =  self.textDict["province"]! + self.textDict["city"]! +  self.textDict["zone"]!
        default:
            print("     nothing     ")
        }
        
    }
}

extension YRAddressCreatedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCreatedCell") as! AddressCreatedCell
        cell.titleLb.text = self.titles[indexPath.row]
        cell.textFiled.delegate = self
        switch indexPath.row {
        case 0:
            self.nameCell = cell
        case 1:
            self.phoneCell = cell
        case 2:
            self.addressCell = cell
            cell.textFiled.userInteractionEnabled = false
        case 3:
            self.detailCell = cell
        default:
            print(#function)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(#function)
        self.view.endEditing(true)
        self.heightContraint?.constant = 200
    }
}

extension YRAddressCreatedViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private class AddressCreatedCell: UITableViewCell {
    
    let titleLb: UILabel = {
        let view = UILabel()
        view.text = "地址"
        view.textColor = YRConfig.mainTextColored
        view.font = UIFont.systemFontOfSize(14.0)
        view.textAlignment = .Left
        view.userInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textFiled: UITextField = {
        let view = UITextField()
        view.placeholder = "自此输入信息"
        view.borderStyle = .RoundedRect
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(titleLb)
        contentView.addSubview(textFiled)
        
        let viewsDict = ["titleLb" : titleLb,
                         "textFiled" : textFiled]
        let vflDict = ["H:|-[titleLb]-|",
                       "H:|-[textFiled]-|",
                       "V:|-[titleLb]-[textFiled(30)]-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
