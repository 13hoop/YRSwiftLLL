//
//  YRInterestViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/6.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRInterestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hexStringColor(hex: "#F3F6F9")
        title = "兴趣爱好"
        
        setUpViews()
    }
    
    private func setUpViews() {
        
        let assistView = UIView()
        assistView.backgroundColor = UIColor.hexStringColor(hex: "#DFDFDF")
        assistView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tipLb)
        view.addSubview(inputText)
        view.addSubview(addBtn)
        view.addSubview(warmLb)
        view.addSubview(assistView)
        view.addSubview(suggestLb)
        
        let viewsDict = ["tipLb" : tipLb,
                         "inputText" : inputText,
                         "addBtn" : addBtn,
                         "warmLb" : warmLb,
                         "assistView" : assistView,
                         "suggestLb" : suggestLb
        ]
        let vflDict = ["H:|-[tipLb]-|",
                       "H:|-[inputText]-0-[addBtn(80)]-|",
                       "V:|-10-[tipLb]-[inputText(45)]-[warmLb]-[assistView(1)]-[suggestLb]",
                       "H:|-[assistView]-|",
                       "V:[addBtn(inputText)]"
        ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllLeading, metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))

    }
    


    private let tipLb: UILabel = {
        let label = UILabel()
        label.text = "共同的兴趣爱好是美好关系的开始"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let inputText: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .None
        textField.backgroundColor = .whiteColor()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("添加", forState: .Normal)
        btn.setTitle("添加", forState: .Highlighted)
        btn.backgroundColor = UIColor.hexStringColor(hex: "#60AFFF")
        btn.titleLabel?.textAlignment = .Center
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let warmLb: UILabel = {
        let label = UILabel()
        label.text = "最多输入8个字"
        label.textColor = UIColor.hexStringColor(hex: "#989898")
        label.font = UIFont.systemFontOfSize(14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let suggestLb: UILabel = {
        let label = UILabel()
        label.text = "已有7个兴趣爱好（7/10）"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}
