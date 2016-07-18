//
//  YRDetailIfnoView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRBasicUnitView: UIView {
    
    var editeBtn: UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.randomColor()
        setUpViews()
    }
    
    func setUpViews() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContentViewPlain: UIView {
    
    var discriptionLb: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    private func setUpViews() {
        
        let discriptionLb = UILabel()
        discriptionLb.textAlignment = .Left
        discriptionLb.translatesAutoresizingMaskIntoConstraints = false
        discriptionLb.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
        
        // 分割线，为了便于布局，就不用layer而使用view实现
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = UIColor.blackColor()

        addSubview(leftLine)
        addSubview(discriptionLb)
        self.discriptionLb = discriptionLb
        
        let viewsDict = [
                "discriptionLb" : discriptionLb,
                "leftLine" : leftLine
                        ]
        let vflDict = [
            "V:|-[discriptionLb]-|",
            "H:|-(10)-[leftLine(1)]-16-[discriptionLb]-|",
            "V:|-(-4)-[leftLine]-(-4)-|",
        ]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YRDetailIfnoView: UIView {
    
    var profile: Profile? {
        didSet {
            
            print("------ detail set here :\n \(profile)-----")
            
            locationView?.titleLB?.text = "当前位置"
            locationView?.discripLB?.text = profile?.province
            
            aboutMeView?.discriptionLb?.text = "不了解我的人，定我为一个深沉却又不纯粹的人，是一个思维如机械咬和器般咬和的人，裁定我是酷、冷，又有点呆板"

            sexSkillView?.titleLB?.text = "性能力"
            sexSkillView?.discripLB?.text = profile?.province
            
//            addressView?.titleLB?.text = "收获地址"
//            addressView?.discripLB?.text = profile?.province

        }
    }

    var locationView: PlainUnitView?
    var aboutMeView: CombinUnitView?
    var interestView: FlowUnitView?
    var sexSkillView: PlainUnitView?
//    var addressView: PlainUnitView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.redColor()
        setUpViews()
    }
    
    private func setUpViews() {
        
        // creat subViews here
        let locationView = PlainUnitView()
        addSubview(locationView)
        self.locationView = locationView
        
        let aboutMeView = CombinUnitView()
        addSubview(aboutMeView)
        self.aboutMeView = aboutMeView

        let interestView = FlowUnitView()
        addSubview(interestView)
        self.interestView = interestView
        
        let sexSkillView = PlainUnitView()
        addSubview(sexSkillView)
        self.sexSkillView = sexSkillView

        // layout views
        let viewsDict = [
            "locationView" : locationView,
            "aboutMeView" : aboutMeView,
            "interestView" : interestView,
            "sexSkillView" : sexSkillView
        ]
        
        let vflArr = [
                        "V:|-0-[locationView]-0-[aboutMeView]-0-[interestView]-0-[sexSkillView]",
                        "H:|-0-[locationView]-0-|",
                        "H:|-0-[aboutMeView]-0-|",
                        "H:|-0-[interestView]-0-|",
                        "H:|-0-[sexSkillView]-0-|"
                        ]
        for vflString in vflArr {
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflString, options: [], metrics: nil, views: viewsDict))
        }
        
        // collectionViewlayout config here
        layoutIfNeeded()
        aboutMeView.detailLayout!.itemSize = CGSizeMake(aboutMeView.detailCollectionView!.frame.width, 40)
        aboutMeView.detailLayout!.minimumLineSpacing = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// PlainUnitView
//-- _ _ | image | title | button |
//  |_ _ |  plain contantView     |
//                   |_ _
//                        --> |   Label |
class PlainUnitView: YRBasicUnitView {
    
    var datas: [String : String]? {
        didSet {
            print("datas is \(datas)")
            
//            titleLB?.text = datas!["title"]! as String
//            discripLB?.text = datas!["title"]! as String
        }
    }

    var titleLB: UILabel?
    var discripLB: UILabel?
    private var imgV: UIImageView?
    
    override func setUpViews() {
        super.setUpViews()
        
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLb = UILabel()
        titleLb.text = "当前位置"
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        self.titleLB = titleLb
        
        let editeBtn = UIButton()
        editeBtn.translatesAutoresizingMaskIntoConstraints = false
        editeBtn.contentHorizontalAlignment = .Right
        editeBtn.setTitle("编辑", forState: .Normal)
        editeBtn.setTitleColor(.blueColor(), forState: .Normal)
        self.editeBtn = editeBtn
        
        // ------------------------------------------------------------------------
        let contentView = ContentViewPlain()
        self.discripLB = contentView.discriptionLb
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imgV)
        addSubview(titleLb)
        addSubview(editeBtn)
        addSubview(contentView)
        
        let viewsDict = [
            "imgV" : imgV,
            "titleLb" : titleLb,
            "editeBtn" : editeBtn,
            "contentView" : contentView
        ]
        let vflDict = ["H:|-[imgV(20)]-[titleLb(100)]-[editeBtn]-|",
                       "V:|-[imgV(30)]-[contentView]-|",
                       "H:|-[contentView]-|"
        ]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
}

// CombinUnitView
//-- _ _ | image | title | button |
//  |_ _ |      contantView       |
//                   |_ _ --> |     label      |
//                        --> | collectionview |
// 1处需要计算：totleHeight = num * 40
class CombinUnitView: YRBasicUnitView {
    
    var detailCollectionView: UICollectionView?
    var detailLayout: UICollectionViewFlowLayout?
    var discriptionLb: UILabel?
    
    // somehow dosen't work!!!
    var countOfCell: Int? {
        willSet {
            print("-- ////////////////////// --")
        }
    }
    
    override func setUpViews() {

//        let count: CGFloat = CGFloat((detailCollectionView?!)
        let totleHeight = 9 * 40

        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        let titleLb = UILabel()
        titleLb.text = "关于我"
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        let editeBtn = UIButton()
        editeBtn.translatesAutoresizingMaskIntoConstraints = false
        editeBtn.contentHorizontalAlignment = .Right
        editeBtn.setTitle("编辑", forState: .Normal)
        editeBtn.setTitleColor(.blueColor(), forState: .Normal)
        self.editeBtn = editeBtn

        // _ _ contentView _ _
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // --> discriptionLb
        let discriptionLb = UILabel()
        discriptionLb.numberOfLines = 2
        discriptionLb.textAlignment = .Left
        discriptionLb.translatesAutoresizingMaskIntoConstraints = false
        self.discriptionLb = discriptionLb
        
        // --> collectionView        
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerClass(UnitViewCell.self, forCellWithReuseIdentifier: "UnitViewCell")
        collectionView.backgroundColor = .whiteColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.detailCollectionView = collectionView  // collectionView
        self.detailLayout = layout                  // layout
        // --> line
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = UIColor.blackColor()
    
        contentView.addSubview(leftLine)
        contentView.addSubview(discriptionLb)
        contentView.addSubview(collectionView)

        // Debug
        discriptionLb.text = "煞风景啊叫佳佳级啊就是发酒疯了啊交流交流交流了解了叫佳佳了解了就离开尽量加快了就了，大多数发生放大舒服"
        
        addSubview(imgV)
        addSubview(titleLb)
        addSubview(editeBtn)
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
                       "V:|-[imgV(30)]-[contentView]-|",
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

// FlowUnitView
//-- _ _ | image | title | button |
//  |_ _ |     contantView        |
//                   |_ _
//                        --> |   collectionView  |[with flow layout]
class FlowUnitView: YRBasicUnitView {
    
    var flowCollectionView: UICollectionView?
    var flowLayout: FlowUnitLayout?
    
    override func setUpViews() {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        let titleLb = UILabel()
        titleLb.text = "7个兴趣爱好"
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        let editeBtn = UIButton()
        editeBtn.translatesAutoresizingMaskIntoConstraints = false
        editeBtn.contentHorizontalAlignment = .Right
        editeBtn.setTitle("编辑", forState: .Normal)
        editeBtn.setTitleColor(.blueColor(), forState: .Normal)
        self.editeBtn = editeBtn

        // _ _ contentView _ _
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

        // --> line
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = UIColor.blackColor()
        
        contentView.addSubview(leftLine)
        contentView.addSubview(collectionView)
        
        addSubview(imgV)
        addSubview(titleLb)
        addSubview(editeBtn)
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
                       "V:|-[imgV(30)]-[contentView(100)]-|",
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

// AlignUnitView
//-- _ _ | image | title | button |
//  |_ _ |     contantView        |
//                   |_ _
//                        --> |   collectionView  |
// 1处需要计算：totleHeight = num * 40
class AlignUnitView: YRBasicUnitView {
    
    var collectionView: UICollectionView?
    var layout: UICollectionViewFlowLayout?
    
    override func setUpViews() {
        
        let totleHeight = 5 * 40

        
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        let titleLb = UILabel()
        titleLb.text = "学历及工作"
        titleLb.translatesAutoresizingMaskIntoConstraints = false
        let editeBtn = UIButton()
        editeBtn.translatesAutoresizingMaskIntoConstraints = false
        editeBtn.contentHorizontalAlignment = .Right
        editeBtn.setTitle("编辑", forState: .Normal)
        editeBtn.setTitleColor(.blueColor(), forState: .Normal)
        self.editeBtn = editeBtn

        // _ _ contentView _ _
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // --> collectionView
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerClass(UnitViewCell.self, forCellWithReuseIdentifier: "UnitViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .whiteColor()
        self.collectionView = collectionView  // collectionView
        self.layout = layout                  // layout
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Vertical
        
        // --> line
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = UIColor.blackColor()
        
        contentView.addSubview(leftLine)
        contentView.addSubview(collectionView)
        
        addSubview(imgV)
        addSubview(titleLb)
        addSubview(editeBtn)
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
                       "V:|-[imgV(30)]-[contentView]-|",
                       "H:|-[contentView]-|",
                       
                       "H:|-(10)-[leftLine(1)]-16-[collectionView]-|",
                       "V:|-[collectionView(totleHeight)]-|",
                       "V:|-(-4)-[leftLine]-(-4)-|"
        ]
        let metrics: [String : AnyObject] = ["totleHeight" : totleHeight]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: metrics, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[5] as String, options: [], metrics: nil, views: viewsDict))
    }
}

// --------- cell -----------
class UnitViewCell: UICollectionViewCell {
    
    var titleLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .ScaleAspectFit
        label.textAlignment = .Center
        return label
    }()
    
    var infoLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLb.text = "婚恋状态: "
        infoLb.text = "dans adfasfasfas xxxx"
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(titleLb)
        contentView.addSubview(infoLb)
        
        let viewsDict = ["titleLb" : titleLb,
                         "infoLb" : infoLb]
        let vflDict = ["H:|[titleLb(100)]-[infoLb]|",
                       "V:|-[titleLb]-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FlowUnitViewCell: UICollectionViewCell {

    var titleLb: UILabel = {
        let label = UILabel()
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    private func setUpViews() {
        contentView.addSubview(titleLb)
        
        let viewsDict = ["titleLb" : titleLb]
        let vflDict = ["H:|-2-[titleLb]-2-|",
                       "V:|-4-[titleLb]-4-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }

    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}

// --------- layout -----------
class FlowUnitLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElementsInRect = super.layoutAttributesForElementsInRect(rect)
        var newAttributesForElementsInRect = [AnyObject]()
       
        var leftMargin: CGFloat = 0.0

        for attributes in attributesForElementsInRect! {

            let refAttributes = attributes 
            if (refAttributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            }else {
                var newleftAligedFrame = refAttributes.frame
                newleftAligedFrame.origin.x = leftMargin
                refAttributes.frame = newleftAligedFrame
            }
            
            leftMargin += refAttributes.frame.size.width + 8
            newAttributesForElementsInRect.append(refAttributes)
        }
       
        return attributesForElementsInRect
    }
}