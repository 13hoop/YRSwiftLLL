//
//  YRInputToolBar.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/3.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRInputToolBar: UIToolbar {
    
    
    var barHeightConstraint: NSLayoutConstraint?
    var textView: YRAdaptedTextView = {
        let view = YRAdaptedTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var audioRecordBtn: YRRecordCustomBtn = {
        let view = YRRecordCustomBtn()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var rightButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 6;
        view.layer.borderWidth = 1.0
        view.setTitle(" ➕ ", forState: .Normal)
        view.setTitle(" 发送 ", forState: .Selected)
        view.setTitle(" 发送 ", forState: .Highlighted)
        view.setTitleColor(UIColor.blueColor(), forState: .Normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var leftButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 6;
        view.layer.borderWidth = 1.0
        view.setTitle(" 🎙️ ", forState: .Normal)
        view.setTitle(" ⌨️ ", forState: .Selected)
        view.setTitleColor(UIColor.blueColor(), forState: .Normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(textView)
        addSubview(audioRecordBtn)
//        bringSubviewToFront(textView)
        barTintColor = UIColor(colorLiteralRed: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1.0)
        
        let viewsDict = ["rightButton" : rightButton,
                         "leftButton" : leftButton,
                         "audioRecordBtn" : audioRecordBtn,
                         "textView" : textView]
        let vflDict = ["H:|-[leftButton(60)]-[textView]-[rightButton(60)]-|",
                       "H:|-[leftButton(60)]-[audioRecordBtn]-[rightButton(60)]-|",
                       "V:|-[audioRecordBtn]-|",
                       "V:|-[textView]-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[2] as String, options: .AlignAllBottom, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[3] as String, options: [], metrics: nil, views: viewsDict))
        barHeightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 44)
        addConstraint(self.barHeightConstraint!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol AdaptedTextViewDelegate {
    func notifyParentView(withHeigh: CGFloat)
}

class YRAdaptedTextView: UITextView {

    var customDelegate: AdaptedTextViewDelegate?
    var maxNumberOfLines = 6
    private let minimumHeight: CGFloat = 30.0

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        font = UIFont.systemFontOfSize(18.0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didChangeTextViewText(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    private func numberOfLines() -> Int {
        guard (self.text.characters.count != 0) else {
            return 1
        }
        return Int(self.contentSize.height / (self.font?.lineHeight)!)
    }

    func didChangeTextViewText(notification: NSNotification) {

        let textView = notification.object as? UITextView
        let numberOfLines = self.numberOfLines()

        guard ((textView?.isEqual(self)) == nil) || numberOfLines <= maxNumberOfLines else {
            return
        }
        
        if self.frame.height > minimumHeight || numberOfLines >= 2 {
            
            var ownHeight = self.contentSize.height
            if numberOfLines == 1 {
                let size = CGSizeMake(CGRectGetWidth(self.bounds), 10000)
                ownHeight = self.sizeThatFits(size).height
            }
            
            var ownFrame = self.frame
            ownFrame.size = CGSizeMake(CGRectGetWidth(self.frame), ownHeight)
            self.frame = ownFrame
            self.scrollRangeToVisible(NSMakeRange(self.text.characters.count, 0))
            
            self.customDelegate?.notifyParentView(self.frame.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

class YRRecordCustomBtn: UIView {
    
    // event
    var touchesBegin: (() -> Void)?
//    var touchesEnded: ((needAbort: Bool) -> Void)?
    var touchesEnded: (()-> Void)?
    var touchesCancelled: (() -> Void)?
    
    // UI
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFontOfSize(15.0)
        titleLabel.text = " 按住录音 "
        titleLabel.textAlignment = .Center
        titleLabel.textColor = .redColor()
        return titleLabel
    }()
    var leftVoiceImageView: UIImageView?
    var rightVoiceImageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
//        backgroundColor = UIColor.yellowColor()
        self.addSubview(titleLabel)
        let viewsDict = ["titleLabel" : titleLabel]
        let vflDict = ["H:|-0-[titleLabel]-0-|",
                       "V:|-0-[titleLabel]-0-|"]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
    }
    
    //MARK: touch event
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        print(#function)
        
        touchesBegin!()
        backgroundColor = UIColor.grayColor()
        titleLabel.text = " 松开发送 "
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        print(#function)

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)

        touchesEnded!()
        backgroundColor = UIColor.yellowColor()
        titleLabel.text = " 按住录音 "
    }
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        print(#function)

        touchesCancelled!()
        backgroundColor = UIColor.yellowColor()
        titleLabel.text = " 按住录音 "
    }
    
}
