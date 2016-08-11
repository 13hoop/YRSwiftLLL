//
//  YRConverstationCells.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/4.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRLeftAudioCell: YRBasicLeftCell {
    let imgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        chatContentView.addSubview(imgV)
        
        let viewsDict = ["imgV" : imgV]
        let vflDict = ["H:|-0-[imgV(<=120)]-0-|",
                       "V:|-0-[imgV]-0-|"]
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }

}

class YRRightAudioCell: YRBasicRightCell {
    
}

class YRLeftImgCell: YRBasicLeftCell {
    let imgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        chatContentView.addSubview(imgV)
        
        let viewsDict = ["imgV" : imgV]
        let vflDict = ["H:|-0-[imgV(120)]-0-|",
                       "V:|-0-[imgV(160)]-0-|"]
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRRightImgCell: YRBasicRightCell {
    
    let imgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .ScaleAspectFit
        //        view.contentMode = .Scale
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        chatContentView.addSubview(imgV)
        
        // debuge -- Resize Ext func has a problem: can't load on time
        imgV.image = UIImage(named: "demoAlbum")?.resizeWithPercentage(0.5)
        //        imgV.image = UIImage(named: "demoAlbum")?.resizeWithWidth(180)
        
        let viewsDict = ["imgV" : imgV]
        let vflDict = ["H:|-0-[imgV(<=120)]-0-|",
                       "V:|-0-[imgV]-0-|"]
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}


class YRLeftTextCell: YRBasicLeftCell{
    
    let chatContentTextLb: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredMaxLayoutWidth = 250;
        view.numberOfLines = -1
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        chatContentView.addSubview(chatContentTextLb)
        
        // debuge
        chatContentTextLb.text = "hello this is chat text, I hope you enjoy this , I know Mybe  this is Shit, sdjasdf;alsdjflsajjjjjjjjjjjjjjjjjjjjjjj 1\n22\n333\n4444\n55555"
        
        let viewsDict = ["chatContentTextLb" : chatContentTextLb]
        let vflDict = ["H:|-10-[chatContentTextLb]-10-|",
                       "V:|-[chatContentTextLb]-|"]
        
        chatContentTextLb.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRRightTextCell: YRBasicRightCell{
    
    let chatContentTextLb: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredMaxLayoutWidth = 250;
        view.numberOfLines = -1
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        chatContentView.addSubview(chatContentTextLb)
        chatContentTextLb.text = "1"
        
        
        let viewsDict = ["chatContentTextLb" : chatContentTextLb]
        let vflDict = ["H:|-10-[chatContentTextLb]-10-|",
                       "V:|-10-[chatContentTextLb]-10-|"]
        
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        
    }
}


class YRBasicLeftCell: YRBasicCoversationCell {

    override func setUpViews() {
        super.setUpViews()
        
        let viewsDict = ["avaterImgV" : avaterImgV,
                         "chatContentView" : chatContentView]
        let vflDict = ["H:|-[avaterImgV(40)]-[chatContentView]",
                       "V:|-[avaterImgV(40)]",
//                       "V:|-[chatContentView(>=avaterImgV)]-|"]
                       "V:[chatContentView]-(8@999)-|"]
//                       "V:[chatContentView]"]

//        chatContentView.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllTop, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRBasicRightCell: YRBasicCoversationCell {
    override func setUpViews() {
        super.setUpViews()
        
        let viewsDict = ["avaterImgV" : avaterImgV,
                         "chatContentView" : chatContentView]
        let vflDict = ["H:[chatContentView]-[avaterImgV(40)]-|",
                       "V:|-[avaterImgV(40)]",
                       "V:[chatContentView]-(8@999)-|"]
        chatContentView.backgroundColor = UIColor.randomColor()
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllTop, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRBasicCoversationCell: UICollectionViewCell {
    
    lazy var nameLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.font = UIFont.systemFontOfSize(10)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avaterImgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        return view
    }()
    
    let chatContentView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    internal func setUpViews() {
        
        // debug
        avaterImgV.backgroundColor = UIColor.randomColor()
        chatContentView.backgroundColor = UIColor.randomColor()
        
        contentView.addSubview(avaterImgV)
        contentView.addSubview(chatContentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
