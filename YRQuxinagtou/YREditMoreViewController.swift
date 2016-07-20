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

    var modelArr:[String] = [" "] {
        didSet {
            tableView.reloadData()
        }
    }
    
    typealias action = (text: String, selectedIndex: NSIndexPath) -> Void
    var callBack: action?
    
    var selectedIndex: NSIndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        setUpViews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let cell = tableView.cellForRowAtIndexPath(selectedIndex!)
        print("- final here: \(cell?.textLabel?.text)")
        
        self.callBack!(text: (cell?.textLabel?.text)!, selectedIndex: selectedIndex!)
        
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
        return self.modelArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: identifer)
        cell.textLabel?.text = modelArr[indexPath.row]
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
        print(cell)
        selectedIndex = indexPath
    }
}

