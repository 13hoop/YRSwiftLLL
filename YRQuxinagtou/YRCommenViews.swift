//
//  YRCommenViews.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/28.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

/*
    home and profile common Unit views
 */

class YRBasicUnitView: UIView {

    var editeBtn: UIButton = {
        let editeBtn = UIButton()
        editeBtn.translatesAutoresizingMaskIntoConstraints = false
        editeBtn.contentHorizontalAlignment = .Right
        editeBtn.setTitle("编辑", forState: .Normal)
        editeBtn.setTitleColor(.blueColor(), forState: .Normal)
        return editeBtn
    }()
    var titleLb: UILabel = {
        let titleLb = UILabel()
        titleLb.textColor = YRConfig.mainTitleTextColored
        titleLb.font = UIFont.systemFontOfSize(16.0)
        titleLb.text = "当前位置"
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        return titleLb
    }()
    var imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.whiteColor()
        setUpViews()
    }
    func setUpViews() {
        addSubview(imgV)
        addSubview(titleLb)
        addSubview(editeBtn)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//   PlainUnitView
// |      Label     |
class PlainUnitView: YRBasicUnitView {
    
    var discripLb: UILabel = {
        let view = UILabel()
        view.textAlignment = .Left
        view.text = "还没有这项信息"
        view.textColor = YRConfig.mainTextColored
        view.font = UIFont.systemFontOfSize(14.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    override func setUpViews() {
        super.setUpViews()
        // _ _ contentView _ _
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = UIColor.grayColor()

        discripLb.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
        contentView.addSubview(discripLb)
        contentView.addSubview(leftLine)
        addSubview(contentView)
        
        imgV.image = UIImage(named: "location")
        
        let viewsDict = [
            "imgV" : imgV,
            "titleLb" : titleLb,
            "editeBtn" : editeBtn,
            "contentView" : contentView,
            "leftLine" : leftLine,
            "discriptionLb": discripLb
        ]
        
        let vflDict = ["H:|-[imgV(20)]-[titleLb(100)]-[editeBtn]-|",
                       "V:|-[imgV(20)]-[contentView]-|",
                       "H:|-[contentView]-|",
                       "V:|-[discriptionLb]-|",
                       "H:|-(10)-[leftLine(1)]-16-[discriptionLb]-|",
                       "V:|-(-4)-[leftLine]-(-4)-|"
        ]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
    }
}

//   CombinUnitView
// |     label      |
// | collectionview |
//        1处需要计算：totleHeight = num * 40
class CombinUnitView: YRBasicUnitView {
    
    var detailCollectionView: UICollectionView?
    var detailLayout: UICollectionViewFlowLayout?
    
    var discriptionLb: UILabel = {
        let view = UILabel()
        view.textAlignment = .Left
        view.text = "还没有这项信息"
        view.textColor = YRConfig.mainTextColored
        view.font = UIFont.systemFontOfSize(14.0)
        view.numberOfLines = 2
        view.textAlignment = .Left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // -- TODO --
    var countOfCell: Int?
    override func setUpViews() {
        super.setUpViews()
        
        imgV.image = UIImage(named: "me")
        
        //        let count: CGFloat = CGFloat((detailCollectionView?!)
        let totleHeight = 9 * 30
        
        // _ _ contentView _ _
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerClass(UnitViewCell.self, forCellWithReuseIdentifier: "UnitViewCell")
        collectionView.backgroundColor = .whiteColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.detailCollectionView = collectionView  // collectionView
        self.detailLayout = layout                  // layout
        
        let backLable = UILabel()
        backLable.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        backLable.textAlignment = .Center
        backLable.font = UIFont.systemFontOfSize(15.0)
        backLable.textColor = UIColor.hexStringColor(hex: YRConfig.themeTintColor)
        collectionView.backgroundView = backLable
        
        // --> line
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = UIColor.grayColor()
        
        contentView.addSubview(leftLine)
        contentView.addSubview(discriptionLb)
        contentView.addSubview(collectionView)
        
        // Debug
        addSubview(contentView)
        
        let viewsDict = ["imgV" : imgV,
                         "titleLb" : titleLb,
                         "editeBtn" : editeBtn,
                         "contentView" : contentView,
                         "leftLine" : leftLine,
                         "discriptionLb" : discriptionLb,
                         "collectionView" : collectionView
        ]
        let vflDict = ["H:|-[imgV(20)]-[titleLb(100)]-[editeBtn]-|",
                       "V:|-[imgV(20)]-[contentView]-|",
                       "H:|-[contentView]-|",
                       
                       "H:|-(10)-[leftLine(1)]-16-[collectionView]-|",
                       "V:|-[discriptionLb]-[collectionView(totleHeight)]-|",
                       "V:|-(-4)-[leftLine]-(-4)-|",
                       "H:[collectionView(discriptionLb)]"
        ]
        let metrics: [String : AnyObject] = ["totleHeight" : totleHeight]
        
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: .AlignAllLeading, metrics: metrics, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[6] as String, options: [], metrics: nil, views: viewsDict))
    }
}

//           FlowUnitView
// |   collectionView(flow layout)  |
class FlowUnitView: YRBasicUnitView {
    
    var flowCollectionView: UICollectionView?
    var flowLayout: FlowUnitLayout?
    
    override func setUpViews() {
        super.setUpViews()
        
        imgV.image = UIImage(named: "hobby")
        
        // contentView
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // --> collectionView
        let layout = FlowUnitLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerClass(FlowUnitViewCell.self, forCellWithReuseIdentifier: "FlowUnitViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .whiteColor()
        self.flowCollectionView = collectionView  // collectionView
        self.flowLayout = layout                  // layout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Vertical
        
        let backLable = UILabel()
        backLable.backgroundColor = UIColor.hexStringColor(hex: YRConfig.plainBackground)
        backLable.textAlignment = .Center
        backLable.font = UIFont.systemFontOfSize(15.0)
        backLable.textColor = UIColor.hexStringColor(hex: YRConfig.themeTintColor)
        collectionView.backgroundView = backLable
        
        // --> line
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = UIColor.grayColor()
        
        contentView.addSubview(leftLine)
        contentView.addSubview(collectionView)
        addSubview(contentView)
        
        let viewsDict = [
            "imgV" : imgV,
            "titleLb" : titleLb,
            "editeBtn" : editeBtn,
            "contentView" : contentView,
            "leftLine" : leftLine,
            "collectionView": collectionView
        ]
        let vflDict = ["H:|-[imgV(20)]-[titleLb(100)]-[editeBtn]-|",
                       "V:|-[imgV(20)]-[contentView(100)]-|",
                       "H:|-[contentView]-|",
                       "H:|-(10)-[leftLine(1)]-16-[collectionView]-|",
                       "V:|-[collectionView]-|",
                       "V:|-(-4)-[leftLine]-(-4)-|"
        ]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
    }
}

//   InsigniaUnitView
// |   collectionView  |
class InsigniaUnitView: YRBasicUnitView {
    
    var collectionView: UICollectionView?
    var layout: UICollectionViewFlowLayout?
    
    override func setUpViews() {
        super.setUpViews()
        
        // _ _ contentView _ _
        let contentView = YRInsigniaView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = contentView.collectionView
        let layout = contentView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(80, 70)
        addSubview(contentView)
        
        imgV.image = UIImage(named: "badge")
        
        let viewsDict = [
            "imgV" : imgV,
            "titleLb" : titleLb,
            "editeBtn" : editeBtn,
            "contentView" : contentView
        ]
        
        let vflDict = ["H:|-[imgV(20)]-[titleLb(100)]-[editeBtn]-|",
                       "V:|-[imgV(20)]-[contentView(90)]-|",
                       "H:|-[contentView]-|"
        ]

        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
}


//   AuthTagUnitView
// |   collectionView  |
class AuthTagUnitView: YRBasicUnitView {

    var layout: UICollectionViewFlowLayout?
    var resumeInfo: UILabel = {
        let titleLb = UILabel()
        titleLb.text = "男， 25岁"
        titleLb.textColor = UIColor.hexStringColor(hex: YRConfig.mainTextColor)
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        return titleLb
    }()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        view.registerClass(AuthTagCell.self, forCellWithReuseIdentifier: "AuthTagCell")
        view.backgroundColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        let contentView = collectionView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(65, 30)
        
        editeBtn.hidden = true
        addSubview(resumeInfo)
        addSubview(contentView)
    
        let viewsDict = [
            "imgV" : imgV,
            "titleLb" : titleLb,
            "resumeInfo" : resumeInfo,
            "contentView" : contentView
        ]
        
        let vflDict = ["H:|-[imgV(18)]-[titleLb]-[resumeInfo]",
                       "V:|-[imgV(18)]-[contentView(35)]-|",
                       "H:|-[contentView]-|"
        ]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        
    }
}