//
//  YRChatlistView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/19.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation
class YRChartListCell: UICollectionViewCell {
    
    var titleLb: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.font = UIFont.systemFontOfSize(15.0)
        label.textColor = YRConfig.mainTitleTextColored
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var infoLb: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = YRConfig.mainTextColored
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var timeLb: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.font = UIFont.systemFontOfSize(13.0)
        label.textColor = YRConfig.mainTextColored
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.backgroundColor = UIColor.randomColor()
        imgV.layer.cornerRadius = 30.0
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        
        contentView.addSubview(titleLb)
        contentView.addSubview(infoLb)
        contentView.addSubview(timeLb)
        contentView.addSubview(imgV)
        
        // debug
        titleLb.text = "Dooobe"
        infoLb.text = "if some this is a realy show, I'll beat them all "
        timeLb.text = "昨天上午9: 30"
        imgV.backgroundColor = UIColor.randomColor()
        
        let viewsDict = ["titleLb" : titleLb,
                         "infoLb" : infoLb,
                         "timeLb" : timeLb,
                         "imgV" : imgV]
        let vflDict = ["H:|-[imgV(60)]-[titleLb(80)]",
                       "V:|-[imgV(60)]-|",
                       "V:|-12-[titleLb]-[infoLb]",
                       "H:[titleLb(80)]-[timeLb]-|",
                       "H:[infoLb]-|"]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllLeading, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[4] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension YRChartListCell: YRCellConfigurabled {
//    func configuireForData(userInfo: YRChatUser) {
//        
//        print(data)
//        // 装填数据 here
//        
//    }
//}
