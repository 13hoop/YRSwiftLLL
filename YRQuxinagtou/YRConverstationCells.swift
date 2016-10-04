//
//  YRConverstationCells.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/4.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YRLeftAudioCell: YRBasicLeftCell {
    
    override var message: AVIMTypedMessage? {
        didSet {
            let audioMsg = message as! AVIMAudioMessage
            timeLb.text = "\(audioMsg.duration)" + " ‘ "
            let url: NSURL = NSURL(string: audioMsg.file.url)!

            // online play
        }
    }
    
    let voicePlayIndicatorImageView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .ScaleAspectFit
        view.image = UIImage(named: "ReceiverVoiceNodePlaying")!.imageWithRenderingMode(.AlwaysTemplate)
        view.tintColor = UIColor.whiteColor()
        return view
    }()
    let timeLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clearColor()
        view.text = " 4' "
        view.textColor = UIColor.whiteColor()
        view.font = UIFont.systemFontOfSize(13.0)
        view.textAlignment = .Right
        return view
    }()
    override func setUpViews() {
        super.setUpViews()
        chatContentView.addSubview(voicePlayIndicatorImageView)
        chatContentView.addSubview(timeLb)
        let viewsDict = ["imgV" : voicePlayIndicatorImageView,
                       "timeLb" : timeLb]
        let vflDict = ["H:|-[imgV(30)]-[timeLb(80)]-|",
                       "V:|-[imgV(25)]-|",
                       "V:[timeLb(imgV)]"]
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    func stopAnimation() {
        if voicePlayIndicatorImageView.isAnimating() {
            voicePlayIndicatorImageView.stopAnimating()
        }
    }
    
    
    func beginAnimation() {
        voicePlayIndicatorImageView.startAnimating()
    }
    
    func setUpVoicePlayIndicatorImageView(send: Bool) {
        var images = NSArray()
        images = NSArray(objects: UIImage(named: "ReceiverVoiceNodePlaying001")!, UIImage(named: "ReceiverVoiceNodePlaying002")!, UIImage(named: "ReceiverVoiceNodePlaying003")!)
        voicePlayIndicatorImageView.image = UIImage(named: "ReceiverVoiceNodePlaying")
        voicePlayIndicatorImageView.animationImages = (images as! [UIImage])
    }
}

class YRRightAudioCell: YRBasicRightCell {
    
    override var message: AVIMTypedMessage? {
        didSet {
            let audioMsg = message as! AVIMAudioMessage
            timeLb.text = "\(audioMsg.duration)" + "`"
            
            let url: NSURL = NSURL(string: audioMsg.file.url)!
            // online play
        }
    }
    
    let voicePlayIndicatorImageView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .ScaleAspectFit
        view.image = UIImage(named: "SenderVoiceNodePlaying")!.imageWithRenderingMode(.AlwaysTemplate)
        view.tintColor = UIColor.whiteColor()
        return view
    }()
    let timeLb: UILabel = {
        let view = UILabel(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clearColor()
        view.text = " 4' "
        view.textColor = UIColor.whiteColor()
        view.font = UIFont.systemFontOfSize(13.0)
        view.textAlignment = .Right
        return view
    }()

    override func setUpViews() {
        super.setUpViews()
        chatContentView.addSubview(voicePlayIndicatorImageView)
        chatContentView.addSubview(timeLb)
        let viewsDict = ["imgV" : voicePlayIndicatorImageView,
                         "timeLb" : timeLb]
        let vflDict = ["H:|-[imgV(30)]-[timeLb(80)]-|",
                       "V:|-[imgV(25)]-|",
                       "V:[timeLb(imgV)]"]
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    func stopAnimation() {
        if voicePlayIndicatorImageView.isAnimating() {
            voicePlayIndicatorImageView.stopAnimating()
        }
    }
    
    
    func beginAnimation() {
        voicePlayIndicatorImageView.startAnimating()
    }
    
    func setUpVoicePlayIndicatorImageView(send: Bool) {
        var images = NSArray()
        images = NSArray(objects: UIImage(named: "SenderVoiceNodePlaying001")!, UIImage(named: "SenderVoiceNodePlaying002")!, UIImage(named: "SenderVoiceNodePlaying003")!)
        voicePlayIndicatorImageView.image = UIImage(named: "SenderVoiceNodePlaying")
        voicePlayIndicatorImageView.animationImages = (images as! [UIImage])
    }
}

class YRLeftImgCell: YRBasicLeftCell {
    
    override var message: AVIMTypedMessage? {
        didSet {
            let imageMsg = message as! AVIMImageMessage
            let url: NSURL = NSURL(string: imageMsg.file.url)!
            imgV.kf_showIndicatorWhenLoading = true
            UIImage.loadImageUsingKingfisher(url, completion: {[weak self] (image, error, cacheType, imageURL) in
                self?.imgV.image = image
                })
        }
    }

    let imgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16.0
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        chatContentView.addSubview(imgV)
        chatContentView.image = nil
        chatContentView.backgroundColor = UIColor.clearColor()
        
        let viewsDict = ["imgV" : imgV]
        let vflDict = ["H:|-0-[imgV(200)]-0-|",
                       "V:|-0-[imgV(150)]-0-|"]
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRRightImgCell: YRBasicRightCell {
    
    override var message: AVIMTypedMessage? {
        didSet {
            let imageMsg = message as! AVIMImageMessage
            let url: NSURL = NSURL(string: imageMsg.file.url)!
            imgV.kf_showIndicatorWhenLoading = true
            UIImage.loadImageUsingKingfisher(url, completion: {[weak self] (image, error, cacheType, imageURL) in
                self?.imgV.image = image
            })
        }
    }
    
    let imgV: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16.0
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        chatContentView.addSubview(imgV)
        chatContentView.image = nil
        chatContentView.backgroundColor = UIColor.clearColor()
        
        let viewsDict = ["imgV" : imgV]
        let vflDict = ["H:|-0-[imgV(200)]-0-|",
                       "V:|-0-[imgV(150)]-0-|"]
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRLeftTextCell: YRBasicLeftCell{
    
    override var message: AVIMTypedMessage? {
        didSet {
            chatContentTextLb.text = message!.text
        }
    }
    
    let chatContentTextLb: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredMaxLayoutWidth = 230
        view.numberOfLines = -1
        view.font = UIFont.systemFontOfSize(14.0)
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        chatContentView.addSubview(chatContentTextLb)
        
        let viewsDict = ["chatContentTextLb" : chatContentTextLb]
        let vflDict = ["H:|-[chatContentTextLb]-|",
                       "V:|-[chatContentTextLb]-|"]
        
        chatContentTextLb.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        chatContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
}

class YRRightTextCell: YRBasicRightCell{
    
    override var message: AVIMTypedMessage? {
        didSet {
            chatContentTextLb.text = message!.text
        }
    }
    
    let chatContentTextLb: UILabel = {
        let view = UILabel()
        view.textColor = .whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredMaxLayoutWidth = 230
        view.numberOfLines = -1
        view.font = UIFont.systemFontOfSize(14.0)
        return view
    }()

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
    
    var message: AVIMTypedMessage?
    var cellTappedAction: ((cell: YRBasicCoversationCell) -> Void)?
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
    
    lazy var chatContentView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedCellContent(_:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    func tappedCellContent(cell: YRBasicCoversationCell) {
        cellTappedAction!(cell: self)
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
