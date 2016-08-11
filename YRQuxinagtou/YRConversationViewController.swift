//
//  YRConversationViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/2.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRConversationViewController: UIViewController {

    var conversation: AVIMConversation? {
        didSet {
            title = conversation?.name
        }
    }

    
    private var messages:[AVIMMessage] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
//    var messages = ["1111111111", "2asdfasfasdfasfasdfasdfasdfasfasfasfafafasfasfasfsafsafasfasfafasfasd", "3just ", "collection view 根据 layout 的 estimatedItemSize 算出估计的 contentSize，有了 contentSize collection view 就开始显示", "2.collection view 在显示的过程中，即将被显示的 cell 根据 autolayout 的约束算出自适应内容的 size", "3.layout 从 collection view 里获取更新过的 size attribute", "4.layout 返回最终的 size attribute 给 collection view", "5.collection 使用这个最终的 size attribute 展示 cell", "9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsKeyboard()
        let item: UIBarButtonItem = UIBarButtonItem(title: "...", style: .Plain, target: self, action: #selector(settingBtnClicked))
        navigationItem.rightBarButtonItem =  item
        setUpView()
    }
    
    private var barBottomConstraint: NSLayoutConstraint?
    private func setUpView() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 5.0
        layout.estimatedItemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 1)
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
        
        let viewsDict = ["collectionView" : collectionView,
                         "audioView" : audioView,
                         "inputBar" : inputBar]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-[collectionView]-0-[inputBar]",
                       "H:|-0-[inputBar]-0-|",
                       "H:|-0-[audioView]-0-|",
                       "V:[audioView(300)]-[inputBar]"]
        for obj in vflDict {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(obj as String, options: [], metrics: nil, views: viewsDict))
        }
        barBottomConstraint = NSLayoutConstraint(item: inputBar, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(barBottomConstraint!)
        
        inputBar.leftButton.selected = false
        inputBar.audioRecordBtn.hidden = true
        audioView.hidden = true
        
        // debuge
        audioView.backgroundColor = UIColor.brownColor()
        
        inputBar.audioRecordBtn.touchesBegin = {[weak self] () -> Void in
            self?.audioView.hidden = false
            let audioFileName = NSUUID().UUIDString
            if let fileURL = NSFileManager.yrAudioMessageURLWithName(audioFileName) {
                print("touch begin")
                YRAudioService.sharedManager.yr_beginRecordWithFileURL(fileURL, audioDelegate: self!)
            }
        }
        
        inputBar.audioRecordBtn.touchesEnded = {
            [weak self] () -> Void in
            self?.audioView.hidden = true
            YRAudioService.sharedManager.yr_endRecord()
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
        collectionView.keyboardDismissMode = .Interactive
        collectionView.registerClass(YRLeftTextCell.self, forCellWithReuseIdentifier: "YRLeftTextCell")
        collectionView.registerClass(YRRightTextCell.self, forCellWithReuseIdentifier: "YRRightTextCell")
        collectionView.registerClass(YRLeftImgCell.self, forCellWithReuseIdentifier: "YRLeftImgCell")
        collectionView.registerClass(YRRightImgCell.self, forCellWithReuseIdentifier: "YRRightImgCell")
        collectionView.registerClass(YRLeftAudioCell.self, forCellWithReuseIdentifier: "YRLeftAudioCell")
        collectionView.registerClass(YRRightAudioCell.self, forCellWithReuseIdentifier: "YRRightAudioCell")
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
    
    //MARK: -- Action --
    func settingBtnClicked() {
        print("拉黑／举报／取消")
    }

    func soundsRecordBtnClicked(sender: UIButton) {
        print(#function)
        self.inputBar.audioRecordBtn.hidden = inputBar.leftButton.selected
        inputBar.leftButton.selected = !inputBar.leftButton.selected
    }
    
    func addBtnClicked(sender: UIButton) {
        
        if sender.selected {
            print(" here ")
            sendTextMessage()
        }else {
            
            YRPhotoPicker.photoMultiPickerDerectilyModeledInAlert(inViewController: self, limited: 4, callBack: { (photoAssets) in
                print(photoAssets)
            })
        }
    }
    
    private func sendAudioMessage() {
        
    }

    private func sendImgMessage() {
        
        
    }
    
    private func sendTextMessage() {
        let inputStr = self.inputBar.textView.text
        let msg = AVIMMessage(content: inputStr)
        let lastIndex = self.messages.count
        let lastIndexPath = NSIndexPath(forItem: lastIndex - 1, inSection: 0)
        conversation?.sendMessage(msg, callback: { [weak self] (success, error) in
            print("success: \(success)")
            self?.collectionView.performBatchUpdates({
                if (lastIndex < 1) {
                    self?.messages.append(msg)
                    self?.collectionView.reloadSections(NSIndexSet(index: 0))
                } else {
                    self?.messages.append(msg)
                    self?.collectionView.insertItemsAtIndexPaths([lastIndexPath])
                }
                }, completion: nil)
            })
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension YRConversationViewController : AVIMClientDelegate {
    func conversation(conversation: AVIMConversation!, didReceiveUnread unread: Int) {
        print(conversation.clientId)
    }
    
    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        print(message.clientId)
    }
    
    func conversation(conversation: AVIMConversation!, messageDelivered message: AVIMMessage!) {
        print(message.content)
    }
}

//  MARK: -- Extension collectionView --
extension YRConversationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
//        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let msg = self.messages[indexPath.row]
//        if indexPath.row % 2 == 0 {
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRLeftTextCell", forIndexPath: indexPath) as! YRLeftTextCell
//            cell.chatContentTextLb.text = content
//            return cell
//        }else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRRightTextCell", forIndexPath: indexPath) as! YRRightTextCell
            cell.chatContentTextLb.text = msg.content
            return cell
//        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // configCell
        if cell.isKindOfClass(YRBasicRightCell.self) {
            let rightCell: YRBasicRightCell = cell as! YRBasicRightCell
            rightCell.avaterImgV.kf_setImageWithURL(NSURL(string: YRUserDefaults.userAvatarURLStr)!)
        }
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
        if self.messages.count != 0 {
            self.collectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: true)
        }
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

//  MARK: -- AVAudioRecorderDelegate --
extension YRConversationViewController: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print(" finished recording \(flag)")
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print(" error : \(error?.localizedDescription)")
    }
}

extension YRConversationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
//        let imageData = UIImageJPEGRepresentation(image, 1.0)!
//        YRService.updateAvatarImage(data: imageData, success: { resule in
//            dispatch_async(dispatch_get_main_queue()) {
//                self.avatarBtn.setBackgroundImage(image, forState: .Normal)
//            }
//        }) { error in
//            print("\(#function) error: \(error)")
//        }
    }
}

