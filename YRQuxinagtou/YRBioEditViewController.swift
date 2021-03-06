//
//  YRBioEditViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/18.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRBioEditViewController: UIViewController {

    var isCallBack: Bool = false
    var defaultBio: String?
    
    var updateData: [String: String] = [:]
    var isSaved: Bool?
    typealias action = (text: String) -> Void
    var callBack: action?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        setUpViews()
        textView.text = defaultBio
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if isCallBack {
            //
        }else {
            self.callBack!(text: textView.text)
        }
    }
    
    private func setUpViews() {
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        view.addSubview(titleLb)
        textView.delegate = self
        view.addSubview(textView)
        
        titleLb.text = isCallBack ? "请输入您对我们的意见或bug反馈" : "想给看到你的人留下什么样的第一印象?"
        let viewsDict = ["titleLb" : titleLb,
                         "textView" : textView]
        let vflDict = ["H:|-[titleLb]-|",
                       "H:|-[textView]-|",
                       "V:|-10-[titleLb]-[textView(240)]"]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    private let titleLb: UILabel = {
        let label = UILabel()
        label.text = "想给看到你的人留下什么样的第一印象？"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFontOfSize(14.0)
        view.textColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

extension YRBioEditViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
