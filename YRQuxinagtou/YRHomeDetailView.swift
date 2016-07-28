//
//  YRHomeDetailView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/28.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRHomeDetailView: UIView {
    var profile: Profile? {
        didSet {
            locationView?.discripLb?.text = profile?.province
            // debug
            locationView?.titleLb.text = "生活在"
            aboutMeView?.discriptionLb?.text = "不了解我的人，定我为一个深沉却又不纯粹的人，是一个思维如机械咬和器般咬和的人，裁定我是酷、冷，又有点呆板"
            sexSkillView?.titleLb.text = "性能力"
            sexSkillView?.discripLb?.text = profile?.province
        }
    }

    var resumeView : AuthTagUnitView?
    var locationView: PlainUnitView?
    var insigniaView:InsigniaUnitView?
    var aboutMeView: CombinUnitView?
    var interestView: FlowUnitView?
    var sexSkillView: PlainUnitView?
    var blackListBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("拉黑", forState: .Normal)
        view.setTitle("拉黑", forState: .Highlighted)
        let color = UIColor.hexStringColor(hex: YRConfig.themeTintColor)
        view.setTitleColor(color, forState: .Normal)
        view.titleLabel?.textAlignment = .Left
        return view
    }()
    var claimsBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("举报", forState: .Normal)
        view.setTitle("举报", forState: .Highlighted)
        let color = UIColor.hexStringColor(hex: YRConfig.themeTintColor)
        view.setTitleColor(color, forState: .Normal)
        view.titleLabel?.textAlignment = .Right
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.redColor()
        setUpViews()
    }
    
    private func setUpViews() {
        
        // creat subViews here
        let resumeView = AuthTagUnitView()
        addSubview(resumeView)
        self.resumeView = resumeView
        
        let locationView = PlainUnitView()
        locationView.editeBtn.hidden = true
        addSubview(locationView)
        self.locationView = locationView
        
        let insigniaView = InsigniaUnitView()
        insigniaView.editeBtn.hidden = true
        addSubview(insigniaView)
        self.insigniaView = insigniaView
        
        let aboutMeView = CombinUnitView()
        aboutMeView.editeBtn.hidden = true
        addSubview(aboutMeView)
        self.aboutMeView = aboutMeView
        
        let interestView = FlowUnitView()
        interestView.editeBtn.hidden = true
        addSubview(interestView)
        self.interestView = interestView
        
        addSubview(blackListBtn)
        addSubview(claimsBtn)
        
        // layout views
        let viewsDict = [
                "resumeView" : resumeView,
                "locationView" : locationView,
                "insigniaView" : insigniaView,
                "aboutMeView" : aboutMeView,
                "interestView" : interestView,
                "blackListBtn" : blackListBtn,
                "claimsBtn" : claimsBtn
        ]
        
        let vflArr = [
            "V:|-[resumeView]-0-[locationView]-0-[insigniaView]-0-[aboutMeView]-0-[interestView]-0-[blackListBtn]",
            "H:|-0-[resumeView]-0-|",
            "H:|-0-[locationView]-0-|",
            "H:|-0-[insigniaView]-0-|",
            "H:|-0-[aboutMeView]-0-|",
            "H:|-0-[interestView]-0-|",
//            "H:|-0-[sexSkillView]-0-|",
            "H:|-[blackListBtn(50)]-(>=100)-[claimsBtn(50)]-|"
        ]
        for vflString in vflArr {
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflString, options: [], metrics: nil, views: viewsDict))
        }
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[blackListBtn(50)]-(>=50)-[claimsBtn(50)]-|", options: .AlignAllBottom, metrics: nil, views: viewsDict))
        
        // collectionViewlayout config here
        layoutIfNeeded()
        aboutMeView.detailLayout!.itemSize = CGSizeMake(aboutMeView.detailCollectionView!.frame.width, 40)
        aboutMeView.detailLayout!.minimumLineSpacing = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
