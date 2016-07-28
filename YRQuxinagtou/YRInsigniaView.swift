//
//  YRInsigniaView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/23.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

enum YRInsigiaViewType: String {
    case authCell = "authCell"
    case insigniaCell = "insigniaCell"
}

class YRInsigniaView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    private func setUpViews() {
        addSubview(collectionView)
        let viewsDict = ["collectionView" : collectionView]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        view.registerClass(InsigniaCell.self, forCellWithReuseIdentifier: YRInsigiaViewType.insigniaCell.rawValue)
        view.registerClass(AuthCell.self, forCellWithReuseIdentifier: YRInsigiaViewType.authCell.rawValue)
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
