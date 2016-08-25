//
//  YREditMoreViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/18.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

private let identifer = "cell"
class YREditMoreViewController: UIViewController {

    var modelArr:[String] = [""] {
        didSet {
            if !isUserHeight {
                tableView.reloadData()
            }
        }
    }
    var isUserHeight: Bool = false
    typealias action = (text: String?, selectedIndex: NSIndexPath) -> Void
    var callBack: action?
    var selectedIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor =  UIColor.hexStringColor(hex: YRConfig.plainBackground)
        tableView.tableFooterView = UIView()
        return tableView
    }()
}

extension YREditMoreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isUserHeight {
            return 60
        } else {
            return self.modelArr.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: identifer)
        
        if isUserHeight {
            cell.textLabel?.text = "\(indexPath.row + 140)" + "mm"
        }else {
            cell.textLabel?.text = modelArr[indexPath.row]
        }
        
        if indexPath == selectedIndex {
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if selectedIndex != nil {
            let lastCell = tableView.cellForRowAtIndexPath(selectedIndex!)
            lastCell?.accessoryType = .None
        }
        cell?.accessoryType = .Checkmark
        selectedIndex = indexPath
        
        let text = cell?.textLabel?.text
        self.callBack!(text: text, selectedIndex: self.selectedIndex!)
        self.navigationController?.popViewControllerAnimated(true)
    }
}

