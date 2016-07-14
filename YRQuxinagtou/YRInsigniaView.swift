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

private struct YRSize {
    static let width: CGFloat = UIScreen.mainScreen().bounds.width / 5
}


class YRInsigniaView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    private func setUpViews() {
        addSubview(collectionView)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(YRSize.width, YRSize.width + 10)
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        
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
        view.backgroundColor = .whiteColor()
        view.registerClass(AuthCell.self, forCellWithReuseIdentifier: YRInsigiaViewType.authCell.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// --- cells ----
class AuthCell: YRInsigiaViewBasicCell {
    
    let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    
    let titleLb: UILabel = {
        let label = UILabel()
        label.text = "照片"
        label.font = UIFont.systemFontOfSize(14.0)
        label.layer.borderWidth = 0.5
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        btn.setTitle("以验证", forState: .Selected)
        btn.setTitle("去验证", forState: .Normal)
        return btn
    }()
    
    override func setUpViews() {
        
        backgroundColor = UIColor.randomColor()
        
        contentView.addSubview(imgV)
        contentView.addSubview(titleLb)
        contentView.addSubview(btn)
        
        let viewsDict = ["imgV" : imgV,
                         "titleLb" : titleLb,
                         "btn" : btn]
        let vflDict = ["H:|-0-[imgV]-0-|",
                       "H:|-0-[titleLb]-0-|",
                       "H:|-0-[btn]-0-|",
                       "V:|-0-[imgV(40)]-0-[titleLb]-0-[btn]-0-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
    }
    
}

class InsigniaCell: YRInsigiaViewBasicCell {

    let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    
    let titleLb: UILabel = {
        let label = UILabel()
        label.text = "男神"
        label.font = UIFont.systemFontOfSize(14.0)
        label.layer.borderWidth = 0.5
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setUpViews() {
        
        backgroundColor = UIColor.randomColor()
        
        contentView.addSubview(imgV)
        contentView.addSubview(titleLb)
        
        let viewsDict = ["imgV" : imgV,
                         "titleLb" : titleLb]
        let vflDict = ["H:|-0-[imgV]-0-|",
                       "H:|-0-[titleLb]-0-|",
                       "V:|-0-[imgV(60)]-0-[titleLb]-0-|"]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRInsigiaViewBasicCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

