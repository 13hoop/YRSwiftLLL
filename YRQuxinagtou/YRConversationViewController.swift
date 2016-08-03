//
//  YRConversationViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/2.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsKeyboard()
        title = "对话"
        setUpView()
    }
    
    var barBottomConstraint: NSLayoutConstraint?
    private func setUpView() {
        view.addSubview(collectionView)
        tabBarController?.tabBar.hidden = true
        inputBar.textView.delegate = self
        inputBar.textView.customDelegate = self
        view.addSubview(inputBar)

        let viewsDict = ["collectionView" : collectionView,
                         "inputBar" : inputBar]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-[inputBar]",
                       "H:|-0-[inputBar]-0-|"]
        for obj in vflDict {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(obj as String, options: [], metrics: nil, views: viewsDict))
        }
        
        barBottomConstraint = NSLayoutConstraint(item: inputBar, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(barBottomConstraint!)
    }
    
    private let inputBar: YRInputToolBar = {
        let view = YRInputToolBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.registerClass(LargePhotoCell.self, forCellWithReuseIdentifier: "LargePhotoCell")
        collectionView.bounces = false
        collectionView.backgroundColor = .whiteColor()
        collectionView.pagingEnabled = true
        return collectionView
    }()
    
    //MARK: DeInit
    deinit {
        // Don't have to do this on iOS 9+, but it still works
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func notifyParentView(withHeigh: CGFloat) {

        print(withHeigh)
        self.inputBar.barHeightConstraint!.constant = (withHeigh > 30.0) ? withHeigh + 16.0 : 44.0;

        UIView.animateWithDuration(0.5, delay: 0, options: .TransitionCurlDown, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
