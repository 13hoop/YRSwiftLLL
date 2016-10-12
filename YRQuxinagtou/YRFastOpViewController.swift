//
//  YRFastOpViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/7.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

private let identifer: String = "basicCell"
private let pickerCellIdentifer: String = "pickerCell"

class YRFastOpViewController: UIViewController {
 
    var showNextBtn: Bool = false
    
    private var sectionTitles: [String] = ["我想", "和谁", "年龄"]
    private var rowTitle: [[String]] = [["约会", "结婚"],["男女都可以", "和一名男生", "和一名女生"], ["any"]]
    private var selectedSectionOneIndex: NSIndexPath?
    private var selectedSectionTwoIndex: NSIndexPath?
    
    private var ageSelected = false
    private var min_age: Int = 18
    private var max_age: Int = 28
    private lazy var nextBtn: UIButton = {
        let view = UIButton(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("下一步", forState: .Normal)
        view.backgroundColor = YRConfig.themeTintColored
        view.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        view.addTarget(self, action: #selector(nextBtnAction(_:)), forControlEvents: .TouchUpInside)
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(BasicCell.self, forCellReuseIdentifier: identifer)
        tableView.registerClass(PickerCell.self, forCellReuseIdentifier: pickerCellIdentifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "速配对象"
        setUpViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        let themedImage = UIImage.pureColor(YRConfig.themeTintColored!)
        navigationController?.navigationBar.setBackgroundImage(themedImage, forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .whiteColor()
        navigationController?.navigationBar.translucent = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if showNextBtn {
            let defaultMeeted = YRUserDefaults.gender == "1" ? 2 : 1
            let defaultMeetedIndex = NSIndexPath(forRow: defaultMeeted, inSection: 1)
            let defaultWantedIndex = NSIndexPath(forRow: 0, inSection: 0)
            tableView.selectRowAtIndexPath(defaultMeetedIndex, animated: false, scrollPosition: .None)
            tableView.selectRowAtIndexPath(defaultWantedIndex, animated: false, scrollPosition: .None)
            self.tableView(tableView, didSelectRowAtIndexPath: defaultMeetedIndex)
            self.tableView(tableView, didSelectRowAtIndexPath: defaultWantedIndex)
            tableView.cellForRowAtIndexPath(defaultWantedIndex)!.accessoryType = .Checkmark
            tableView.cellForRowAtIndexPath(defaultMeetedIndex)!.accessoryType = .Checkmark
        }
    }
    
    private func setUpViews() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        view.addSubview(nextBtn)
        let viewsDict = ["tableView" : tableView,
                         "nextBtn" : nextBtn]
        let vflDict = ["H:|-0-[tableView]-0-|",
                       "V:|-[tableView]-[nextBtn(44)]-|"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: viewsDict))
        nextBtn.hidden = !showNextBtn
        nextBtn.backgroundColor = YRConfig.disabledColored
    }
    
    // Action
    func nextBtnAction(sender: UIButton) {
        
        guard ageSelected else {
            return
        }
        
        guard max_age > min_age else {
            return
        }
        
        print("woxiang: \(selectedSectionOneIndex)  heshei; \(selectedSectionTwoIndex) age: \(min_age) + \(max_age)")
        
        let vc = UIStoryboard(name: "Regist", bundle: nil).instantiateViewControllerWithIdentifier("YRRegisterInfoViewController") as! YRRegisterInfoViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension YRFastOpViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 120.0
        }else {
            return 44.0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTitle[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(pickerCellIdentifer) as! PickerCell
            cell.picker.delegate = self
            print("- load default age here -")
            cell.picker.selectRow(4, inComponent: 0, animated: false)
            cell.picker.selectRow(10, inComponent: 1, animated: false)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(identifer) as! BasicCell
            cell.titleLb.text = self.rowTitle[indexPath.section][indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // single selection in all section
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            if (selectedSectionOneIndex == nil) {
                let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
                selectedCell?.accessoryType = .Checkmark
            }else {
                let lastCell = tableView.cellForRowAtIndexPath(selectedSectionOneIndex!)
                lastCell?.accessoryType = .None
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            }
            selectedSectionOneIndex = indexPath
        case 1:
            if (selectedSectionTwoIndex == nil) {
                let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
                selectedCell?.accessoryType = .Checkmark
            }else {
                let lastCell = tableView.cellForRowAtIndexPath(selectedSectionTwoIndex!)
                lastCell?.accessoryType = .None
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            }
            selectedSectionTwoIndex = indexPath
        case 2:
            if (selectedSectionTwoIndex == nil) {
                let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
                selectedCell?.accessoryType = .Checkmark
            }else {
                let lastCell = tableView.cellForRowAtIndexPath(selectedSectionTwoIndex!)
                lastCell?.accessoryType = .None
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            }
            selectedSectionTwoIndex = indexPath
        default:
            print(indexPath)
        }
    }
}

extension YRFastOpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 40
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let btn = pickerView.viewForRow(row, forComponent: component) as! UIButton
        btn.selected = !btn.selected
        switch component {
        case 0:
            print("min_age = \(row)")
            self.min_age = row + 18
        default:
            print("max_age = \(row)")
            self.max_age = row + 18
        }
        self.ageSelected = true
        self.nextBtn.backgroundColor = self.min_age < self.max_age ? YRConfig.themeTintColored : YRConfig.disabledColored
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        pickerView.subviews[1].hidden = true
        let btn = UIButton()
        btn.setTitleColor(.redColor(), forState: .Selected)
        btn.setTitleColor(.blackColor(), forState: .Normal)
        btn.setTitle("\(row + 18)", forState: .Normal)
        if component == 0 {
            btn.setTitle("\(row + 18) 岁", forState: .Selected)
        }else {
            btn.setTitle("\(row + 18) 岁", forState: .Selected)
        }
        return btn
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70.0
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20.0
    }
    
}

private class BasicCell: UITableViewCell {
    
    let titleLb: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexStringColor(hex: "#656565")
        label.font = UIFont.systemFontOfSize(14.0)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    private func setUpViews()  {
        let x: CGFloat = 15.0
        let y: CGFloat = 0
        let w = contentView.bounds.width
        let h = contentView.bounds.height
        titleLb.frame = CGRectMake(x, y, w, h)
        contentView.addSubview(titleLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
