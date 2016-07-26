//
//  YRInterestViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/6.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRInterestViewController: UIViewController {
    
    var interest: [String] = ["篮球", "haohaoxuexi", "听英语", "de", "看周星驰的电影", "电脑噶松手"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        title = "兴趣爱好"
        setUpViews()
    }
    
    private func setUpViews() {
        
        let assistView = UIView()
        assistView.backgroundColor = UIColor.hexStringColor(hex: "#DFDFDF")
        assistView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tipLb)
        
        inputText.delegate = self
        view.addSubview(inputText)
        
        addBtn.addTarget(self, action: #selector(addInterestClicked), forControlEvents: .TouchUpInside)
        view.addSubview(addBtn)
        
        view.addSubview(warmLb)
        view.addSubview(assistView)
        view.addSubview(suggestLb)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let backLable = UILabel()
        backLable.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        backLable.textAlignment = .Center
        backLable.font = UIFont.systemFontOfSize(15.0)
        backLable.textColor = UIColor.hexStringColor(hex: YRConfig.themeTintColor)
        collectionView.backgroundView = backLable
        view.addSubview(collectionView)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Vertical

        
        let viewsDict = ["tipLb" : tipLb,
                         "inputText" : inputText,
                         "addBtn" : addBtn,
                         "warmLb" : warmLb,
                         "assistView" : assistView,
                         "suggestLb" : suggestLb,
                         "collectionView": collectionView
        ]
        let vflDict = ["H:|-[tipLb]-|",
                       "H:|-[inputText]-0-[addBtn(80)]-|",
                       "V:|-10-[tipLb]-[inputText(45)]-[warmLb]-[assistView(1)]-[suggestLb]-[collectionView(200)]",
                       "H:|-[assistView]-|",
                       "V:[addBtn(inputText)]",
                       "H:|-[collectionView]-|"
        ]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllLeading, metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    // -- Action --
    func addInterestClicked() {
        interest.append(inputText.text!)
        inputText.resignFirstResponder()
        let index = NSIndexPath(forItem: interest.count - 1, inSection: 0)
        collectionView.performBatchUpdates({
            self.collectionView.insertItemsAtIndexPaths([index])
            }, completion: nil)
    }
    
    let collectionView: UICollectionView = {
        let layout = FlowUnitLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerClass(InterestCell.self, forCellWithReuseIdentifier: "InterestCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
    
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
        textField.clearsOnBeginEditing = true
        textField.borderStyle = .None
        textField.backgroundColor = .whiteColor()
        textField.clearButtonMode = .WhileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let addBtn: UIButton = {
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

extension YRInterestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension YRInterestViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        collectionView.performBatchUpdates({
            self.interest.removeAtIndex(indexPath.row)
            collectionView.deleteItemsAtIndexPaths([indexPath])
            }, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let backLable = collectionView.backgroundView as? UILabel {
            if self.interest.isEmpty {
                backLable.text = "您还没有添加任何兴趣"
            }else {
                backLable.text = ""
            }
        }
        return self.interest.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InterestCell", forIndexPath: indexPath) as! InterestCell
        cell.titleLb.text = self.interest[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let word = self.interest[indexPath.item] as String
        let size = word.stringConstrainedSize(UIFont.systemFontOfSize(17.0))
        let itemSize = CGSizeMake(size.width + 16 + 10 + 30, size.height + 16 )
        return itemSize
    }
}

private class InterestCell: FlowUnitViewCell {
    
    let deleteBtn: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "delete"), forState: .Normal)
        view.titleLabel?.font = UIFont.systemFontOfSize(11.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.userInteractionEnabled = false
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        titleLb.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(deleteBtn)
        
        let viewsDict = ["deleteBtn" : deleteBtn,
                         "titleLb" : titleLb]
        let vflDict = ["H:[deleteBtn(15)]",
                       "V:[deleteBtn(15)]"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraint(NSLayoutConstraint(item: deleteBtn, attribute: .CenterY, relatedBy: .Equal, toItem: titleLb, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: deleteBtn, attribute: .Trailing, relatedBy: .Equal, toItem: titleLb, attribute: .Trailing, multiplier: 1.0, constant: -5))
    }
}



