//
//  YRConversationViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/2.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "对话"
        setUpView()
    }
    
    private func setUpView() {
        view.addSubview(collectionView)
        view.addSubview(inputBar)
        
        let viewsDict = ["collectionView" : collectionView,
                         "inputBar" : inputBar]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-|",
                       "H:|-0-[inputBar]-0-|",
                       "V:[inputBar(40)]-0-|"]
        for obj in vflDict {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(obj as String, options: [], metrics: nil, views: viewsDict))
        }
    }
    
    private let inputBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.registerClass(LargePhotoCell.self, forCellWithReuseIdentifier: "LargePhotoCell")
        collectionView.bounces = false
        collectionView.backgroundColor = .whiteColor()
        collectionView.pagingEnabled = true
        return collectionView
    }()
}
