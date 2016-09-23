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
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        chatContentView.addSubview(imgV)
        
        let viewsDict = ["imgV" : imgV]
        let vflDict = ["H:|-0-[imgV(<=200)]-0-|",
                       "V:|-0-[imgV(<=150)]-0-|"]
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}


class YRLeftTextCell: YRBasicLeftCell{
    
    let chatContentTextLb: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredMaxLayoutWidth = 230
        view.numberOfLines = -1
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setUpViews() {
        super.setUpViews()
        
        chatContentView.addSubview(chatContentTextLb)
        
        // debuge
        chatContentTextLb.text = "hello this is chat text, I hope you enjoy this , I know Mybe  this is Shit, sdjasdf;alsdjflsajjjjjjjjjjjjjjjjjjjjjjj 1\n22\n333\n4444\n55555"
        
        let viewsDict = ["chatContentTextLb" : chatContentTextLb]
        let vflDict = ["H:|-[chatContentTextLb]-|",
                       "V:|-[chatContentTextLb]-|"]
        
        chatContentTextLb.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRRightTextCell: YRBasicRightCell{
    
    let chatContentTextLb: UILabel = {
        let view = UILabel()
        view.textColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredMaxLayoutWidth = 230
        view.numberOfLines = -1
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        chatContentView.addSubview(chatContentTextLb)
        chatContentTextLb.text = "1"
        let viewsDict = ["chatContentTextLb" : chatContentTextLb]
        let vflDict = ["H:|-[chatContentTextLb]-|",
                       "V:|-[chatContentTextLb]-|"]
        
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        
    }
}


class YRBasicLeftCell: YRBasicCoversationCell {

    override func setUpViews() {
        super.setUpViews()
        chatContentView.image = UIImage(named: "bubble_gray")!.imageWithRenderingMode(.AlwaysTemplate)
        chatContentView.tintColor = UIColor(white: 0.90, alpha: 1)

        let viewsDict = ["avaterImgV" : avaterImgV,
                         "chatContentView" : chatContentView]
        let vflDict = ["H:|-[avaterImgV(0)]-0-[chatContentView]",
                       "V:|-[avaterImgV(36)]",
                       "V:|-[chatContentView]-(8@999)-|"]

        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllTop, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRBasicRightCell: YRBasicCoversationCell {
    override func setUpViews() {
        super.setUpViews()
        chatContentView.image = UIImage(named: "bubble_blue")!.imageWithRenderingMode(.AlwaysTemplate)
        chatContentView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)

        
        let viewsDict = ["avaterImgV" : avaterImgV,
                         "chatContentView" : chatContentView]
        let vflDict = ["H:[chatContentView]-0-[avaterImgV(0)]-|",
                       "V:|-[avaterImgV(36)]",
                       "V:|-[chatContentView]-(8@999)-|"]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllTop, metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRBasicCoversationCell: UITableViewCell {
    
    lazy var nameLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.font = UIFont.systemFontOfSize(10)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var avaterImgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18.0
        view.layer.masksToBounds = true
        return view
    }()
    
    let chatContentView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    internal func setUpViews() {
        // debug
        avaterImgV.backgroundColor = UIColor.randomColor()
        contentView.addSubview(avaterImgV)
        contentView.addSubview(chatContentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// --- header ---
class YRMessageHeaderView: UIView {
    
    lazy var timeLb : UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .Center
        view.textColor = YRConfig.mainTextColored
        view.font = UIFont.systemFontOfSize(11.0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    private func setUpViews() {
        addSubview(timeLb)
        let viewsDict = ["timeLb" : timeLb]
        let vflDict = ["H:|-0-[timeLb]-0-|",
                       "V:|-0-[timeLb]-0-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

