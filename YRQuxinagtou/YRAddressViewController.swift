//
//  YRAddressViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/18.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAddressViewController: UIViewController {
    
    lazy var addressPicker: UIPickerView = {
        let view = UIPickerView(frame: CGRectZero)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 为了少解析一次
    private let province = ["北京", "安徽", "福建", "甘肃", "广东", "广西","贵州","海南", "河北", "河南", "黑龙江", "湖北", "湖南", "吉林", "江苏", "江西", "辽宁", "内蒙古", "宁夏", "青海", "山东", "山西", "陕西", "上海", "四川", "天津", "西藏", "新疆", "云南", "浙江", "重庆", "香港", "澳门", "台湾"]

    private var selectedProvinceKey = 0

    private var all_province_city : [String: AnyObject] = [:]
    private var all_city_district : [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .whiteColor()
        
        fetchAddressData()
        setUpViews()
    }

    private func setUpViews() {
        view.addSubview(addressPicker)
        
        let viewsDict = ["addressPicker" : addressPicker]
        let vflDict = ["H:|-0-[addressPicker]-0-|",
                       "V:|-200-[addressPicker(100)]"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    private func fetchAddressData() {
        YRService.requiredAddressData(success: { result in
            if let data = result!["data"] {
                if let all_province_city = data["all_province_city"] {
                    self.all_province_city = all_province_city as! [String : AnyObject]
                    print(self.all_province_city)
                }
            }
            
            }, fail: { error in
            print("required address data error:\(error)")
        })
    }
}

extension YRAddressViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return province[row]
        case 1:
            return self.selectedProvinceKey == 0 ? "未选择" : ""
        default:
            let title = " xxxx "
            return title
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        // value -> key
        switch component {
        case 0:
            self.selectedProvinceKey = row + 1
        default:
            print("     nothing     ")
        }
    }
}
