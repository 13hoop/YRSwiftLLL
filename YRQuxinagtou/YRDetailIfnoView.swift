//
//  YRDetailIfnoView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/1.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRDetailIfnoView: UIView {

    var locationView: PlainUnitView?
    var aboutMeView: CombinUnitView?
    var interestView: FlowUnitView?
    var sexSkillView: PlainUnitView?
    
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
        aboutMeView.detailLayout!.itemSize = CGSizeMake(aboutMeView.detailCollectionView!.frame.width, 30)
        aboutMeView.detailLayout!.minimumLineSpacing = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}