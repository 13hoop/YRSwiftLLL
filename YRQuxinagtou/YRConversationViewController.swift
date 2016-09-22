//
//  YRConversationViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/2.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YRConversationViewController: UIViewController, AVIMClientDelegate {

    // conversation
    var conversation: AVIMConversation? {
        didSet {
            if let nickNmae = conversation?.name {
                titleLb.text = nickNmae
            }
            print("\(conversation?.imClient)---\(AVIMClient.defaultClient())")
        }
    }
    
    var profile: Profile? {
        didSet {
            if let urlStr = profile?.avatar {
                let url = NSURL(string: urlStr)!
                UIImage.loadImageUsingKingfisher(url, completion: { [weak self] (image, error, cacheType, imageURL) in
                    if let img = image {
                        self?.userImageView.image = img.resizeWithWidth(40.0)
                    }
                })
            }
        
        }
    }

    private var messages:[AVIMTypedMessage] = [] {
        didSet {
            print("🗾🗾 \(messages.count) 🗾🗾")
            collectionView.reloadData()
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
        collectionView.registerClass(YRMessageHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YRMessageHeaderView")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
    private var barBottomConstraint: NSLayoutConstraint?

    private let titleView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 100, 40))
        return view
    }()
    private let titleLb: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsKeyboard()
        notificationsRecieveMessage()
        setUpNavBar()
        setUpView()
    }

    func notificationsRecieveMessage() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.didReciveMessage(_:)), name: "YRClientDidReciveMessageNotification", object: nil)
    }
    
    func didReciveMessage(notification: NSNotification) {
        print("  notified message ")
        if  let userInfo = notification.userInfo {
            let messageInfo = userInfo["info"] as! AVIMTypedMessage
            self.messages.append(messageInfo)
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "notificationsRecieveMessage", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setUpNavBar() {
        let continarView = UIView()
        continarView.translatesAutoresizingMaskIntoConstraints = false
        continarView.addSubview(userImageView)
        continarView.addSubview(titleLb)
        titleView.addSubview(continarView)
        
        let viewsDict = ["userImageView" : userImageView,
                         "titleLb" : titleLb,
                         "continarView" : continarView]
        let vflDict = ["H:|[userImageView(40)]-5-[titleLb]|",
                       "V:|[userImageView(40)]|"]
        continarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[0] as String, options: .AlignAllCenterY, metrics: nil, views: viewsDict))
        continarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vflDict[1] as String, options: [], metrics: nil, views: viewsDict))
        titleView.addConstraint(NSLayoutConstraint(item: continarView, attribute: .CenterX, relatedBy: .Equal, toItem: titleView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: continarView, attribute: .CenterY, relatedBy: .Equal, toItem: titleView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        navigationItem.titleView = titleView
        
        let item: UIBarButtonItem = UIBarButtonItem(title: "...", style: .Plain, target: self, action: #selector(settingBtnClicked))
        navigationItem.rightBarButtonItem =  item
    }
    private func setUpView() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 5.0
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0)
        layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 15)
        layout.estimatedItemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCollectionViewAction))
        collectionView.addGestureRecognizer(tap)
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
        
        // 保证随机键盘弹出和回缩
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
            sendTextMessage()
        }else {
            YRPhotoPicker.photoMultiPickerDerectilyModeledInAlert(inViewController: self, limited: 4, callBack: {[weak self] (images) in
                print(" -- Finally: recieve the picker photoAssets here ")
                print(images)
                
                for img in images {
                    let attr = ["width" : img.size.width,
                               "height" : img.size.height]
                    if let imageData: NSData = UIImagePNGRepresentation(img) {
                        let imageFile = AVFile(data: imageData)
                        let msg = AVIMImageMessage(text: "", file: imageFile, attributes: attr)
                        self?.sendImgMessage(msg)
                    }
                }
            })
        }
    }

    func tapCollectionViewAction() {
        print(" if is not Tap cell Text, then is collectionView Tap Action! ")
        self.inputBar.textView.resignFirstResponder()
    }
    
    private func sendAudioMessage() {
        
    }
    
    private func sendImgMessage(imageMessage: AVIMTypedMessage) {
        insertAndSendConversation(imageMessage)
    }
    
    private func sendTextMessage() {
        let inputStr = self.inputBar.textView.text
        let msg = AVIMTextMessage(text: inputStr, attributes: [:])
        insertAndSendConversation(msg)
        
        guard self.messages.count > 0 else { return }
        let index = NSIndexPath(forItem: 0, inSection: self.messages.count - 1)
        self.collectionView.scrollToItemAtIndexPath(index, atScrollPosition: .Bottom, animated: true)
    }
    
    private func insertAndSendConversation(message: AVIMTypedMessage) {
        
        let lastSection = self.messages.count
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        conversation?.sendMessage(message, callback: { [weak self] (success, error) in
            self?.collectionView.performBatchUpdates({
                self?.messages.append(message)
                let set: NSIndexSet = NSIndexSet(index: lastSection)
                self?.collectionView.insertSections(set)
            }, completion: { [weak self] _ in

                let bottomOffset = (self?.collectionView.contentSize.height)! - (self?.collectionView.contentOffset.y)!
                print(bottomOffset)
                self?.inputBar.textView.text = ""
                self?.inputBar.barHeightConstraint!.constant = 44.0;
                self?.collectionView.contentOffset = CGPointMake(0, (self?.collectionView.contentSize.height)! - bottomOffset);
                CATransaction.commit()
            })
//            UIView.animateWithDuration(0, delay: <#T##NSTimeInterval#>, usingSpringWithDamping: <#T##CGFloat#>, initialSpringVelocity: <#T##CGFloat#>, options: <#T##UIViewAnimationOptions#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
//                })
        })
    }
}

//  MARK: -- Extension collectionView --
extension YRConversationViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.messages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let msg = self.messages[indexPath.section]
        
        if msg.ioType == AVIMMessageIOTypeOut {
            switch msg.mediaType {
            case -2:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRRightImgCell", forIndexPath: indexPath) as! YRRightImgCell
                return cell
            case -1:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRRightTextCell", forIndexPath: indexPath) as! YRRightTextCell
                return cell
            default:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRRightTextCell", forIndexPath: indexPath) as! YRRightTextCell
                cell.chatContentTextLb.text = msg.content
                return cell
            }
        }else {
            switch msg.mediaType {
            case -2:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRLeftImgCell", forIndexPath: indexPath) as! YRLeftImgCell
                return cell
            case -1:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRLeftTextCell", forIndexPath: indexPath) as! YRLeftTextCell
                return cell
            default:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRLeftTextCell", forIndexPath: indexPath) as! YRLeftTextCell
                cell.chatContentTextLb.text = msg.content
                return cell
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let msg = self.messages[indexPath.section]
        
        if cell.isKindOfClass(YRBasicRightCell.self) {
            let rightCell: YRBasicRightCell = cell as! YRBasicRightCell
            rightCell.avaterImgV.kf_showIndicatorWhenLoading = true
            rightCell.avaterImgV.kf_setImageWithURL(NSURL(string: YRUserDefaults.userAvatarURLStr)!)
            switch msg.mediaType {
            case -2:
                let imageMsg = msg as! AVIMImageMessage
                let imageCell = rightCell as! YRRightImgCell
                let url: NSURL = NSURL(string: imageMsg.file.url)!
                UIImage.loadImageUsingKingfisher(url, completion: {[weak imageCell] (image, error, cacheType, imageURL) in
                    imageCell?.imgV.image = image
                })
            case -1:
                let textMsg = msg as! AVIMTextMessage
                let textCell = rightCell as! YRRightTextCell
                textCell.chatContentTextLb.text = textMsg.text
                
            default:
                print(#function)
            }
        }else {
            let leftCell: YRBasicLeftCell = cell as! YRBasicLeftCell
            switch msg.mediaType {
            case -2:
                let imageMsg = msg as! AVIMImageMessage
                let imageCell = leftCell as! YRLeftImgCell
                let url: NSURL = NSURL(string: imageMsg.file.url)!
                UIImage.loadImageUsingKingfisher(url, completion: {[weak imageCell] (image, error, cacheType, imageURL) in
                    imageCell?.imgV.image = image
                })
            case -1:
                let textMsg = msg as! AVIMTextMessage
                let textCell = leftCell as! YRLeftTextCell
                textCell.chatContentTextLb.text = textMsg.text
                
            default:
                print(#function)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusedView = UICollectionReusableView(frame: CGRectZero)
        guard kind == UICollectionElementKindSectionHeader else {
            return reusedView
        }
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "YRMessageHeaderView", forIndexPath: indexPath) as! YRMessageHeaderView
        header.timeLb.text = "2015.09.22 15:00"
        reusedView = header
        return reusedView
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
            let endValue = userInfo[UIKeyboardFrameEndUserInfoKey],
            let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey]
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
        guard self.messages.count > 0 else {
            return true
        }
        
        let index = NSIndexPath(forItem: 0, inSection: self.messages.count - 1)
        self.collectionView.scrollToItemAtIndexPath(index, atScrollPosition: .Bottom, animated: true)
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    func textViewDidChange(textView: UITextView) {
        guard let text = textView.text else { return }
        self.inputBar.rightButton.selected = true
        print(text)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.inputBar.rightButton.selected = false
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

// MARK: -- UIImagePickerControllerDelegate --
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

