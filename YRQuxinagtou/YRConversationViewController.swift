//
//  YRConversationViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/2.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRConversationViewController: UIViewController {

    var client: AVIMClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsKeyboard()
        title = "对话"
        setUpView()
    }
    
    var barBottomConstraint: NSLayoutConstraint?
    private func setUpView() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 5.0
        layout.estimatedItemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 300)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)

        tabBarController?.tabBar.hidden = true
        inputBar.textView.delegate = self
        inputBar.textView.customDelegate = self
        view.addSubview(inputBar)
        
        view.addSubview(audioView)
        
        inputBar.leftButton.addTarget(self, action: #selector(soundsRecordBtnClicked(_:)), forControlEvents: .TouchUpInside)
        inputBar.rightButton.addTarget(self, action: #selector(addBtnClicked(_:)), forControlEvents: .TouchUpInside)
        
        // debuge
        audioView.backgroundColor = UIColor.brownColor()
        
        let viewsDict = ["collectionView" : collectionView,
                         "audioView" : audioView,
                         "inputBar" : inputBar]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-[inputBar]",
                       "H:|-0-[inputBar]-0-|",
                       "H:|-0-[audioView]-0-|",
                       "V:[audioView(300)]-[inputBar]"]
        for obj in vflDict {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(obj as String, options: [], metrics: nil, views: viewsDict))
        }
        
        barBottomConstraint = NSLayoutConstraint(item: inputBar, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(barBottomConstraint!)
        
        
        audioView.hidden = true
        inputBar.audioRecordBtn.touchesBegin = {[weak self] () -> Void in
            self?.audioView.hidden = false
        }
        inputBar.audioRecordBtn.touchesEnded = {[weak self] () -> Void in
            self?.audioView.hidden = true
        }
    }
    
    private let inputBar: YRInputToolBar = {
        let view = YRInputToolBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let audioView: YRAudioView = {
        let view = YRAudioView(frame: CGRectZero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(YRLeftTextCell.self, forCellWithReuseIdentifier: "YRLeftTextCell")
        collectionView.registerClass(YRRightImgCell.self, forCellWithReuseIdentifier: "YRRightImgCell")
        collectionView.registerClass(YRRightTextCell.self, forCellWithReuseIdentifier: "YRRightTextCell")
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
    
    //MARK: Action
    func soundsRecordBtnClicked(sender: UIButton) {
        
        inputBar.leftButton.selected = !inputBar.leftButton.selected
        
        // chage input show record Btn
        
        print(#function)

    }
    func addBtnClicked(sender: UIButton) {
        print(#function)

    }
    //MARK: DeInit
    deinit {
        // Don't have to do this on iOS 9+, but it still works
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

//  MARK: -- Extension collectionView --
extension YRConversationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 400
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRLeftTextCell", forIndexPath: indexPath) as! YRLeftTextCell
            cell.backgroundColor = UIColor.randomColor()
            return cell
        }else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRRightImgCell", forIndexPath: indexPath) as! YRRightImgCell
            cell.backgroundColor = UIColor.randomColor()
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.row)
    }
}


//  MARK: -- Extension Keyboard --
extension YRConversationViewController {

    func notificationsKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShowOrHide(notification: NSNotification) {
        if  let userInfo = notification.userInfo,
            endValue = userInfo[UIKeyboardFrameEndUserInfoKey],
            durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey]
        {
            
            let endRect = endValue.CGRectValue
            let heightToMove = (notification.name == "UIKeyboardWillShowNotification") ? -endRect.height : 0
            self.barBottomConstraint?.constant = heightToMove
            
            let duration = durationValue.doubleValue
            UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
}

//  MARK: -- UITextViewDelegate --
extension YRConversationViewController: UITextViewDelegate, AdaptedTextViewDelegate {
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        self.inputBar.rightButton.selected = true

        let lastSection = self.collectionView.numberOfSections() - 1
        let lastItem = self.collectionView.numberOfItemsInSection(lastSection) - 1
        let lastIndexPath: NSIndexPath = NSIndexPath(forItem: lastItem, inSection: lastSection)
        self.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: true)
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func notifyParentView(withHeigh: CGFloat) {
        self.inputBar.barHeightConstraint!.constant = (withHeigh > 30.0) ? withHeigh + 16.0 : 44.0;
        UIView.animateWithDuration(0.5, delay: 0, options: .TransitionCurlDown, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
