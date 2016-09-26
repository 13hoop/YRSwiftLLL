//
//  YRConversationViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/9/23.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YRConversationViewController:  UIViewController, AVIMClientDelegate {
    
    // conversation
    var conversation: AVIMConversation? {
        didSet {
            if let nickNmae = conversation?.name {
                titleLb.text = nickNmae
            }
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
            tableView.reloadData()
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
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .Interactive
        tableView.registerClass(YRLeftTextCell.self, forCellReuseIdentifier: "YRLeftTextCell")
        tableView.registerClass(YRRightTextCell.self, forCellReuseIdentifier: "YRRightTextCell")
        tableView.registerClass(YRLeftImgCell.self, forCellReuseIdentifier: "YRLeftImgCell")
        tableView.registerClass(YRRightImgCell.self, forCellReuseIdentifier: "YRRightImgCell")
        tableView.registerClass(YRLeftAudioCell.self, forCellReuseIdentifier: "YRLeftAudioCell")
        tableView.registerClass(YRRightAudioCell.self, forCellReuseIdentifier: "YRRightAudioCell")
        tableView.alwaysBounceVertical = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .whiteColor()
        return tableView
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCollectionViewAction))
        tableView.addGestureRecognizer(tap)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        view.addSubview(tableView)
        
        tabBarController?.tabBar.hidden = true
        inputBar.textView.delegate = self
        inputBar.textView.customDelegate = self
        view.addSubview(inputBar)
        view.addSubview(audioView)
        
        inputBar.leftButton.addTarget(self, action: #selector(soundsRecordBtnClicked(_:)), forControlEvents: .TouchUpInside)
        inputBar.rightButton.addTarget(self, action: #selector(addBtnClicked(_:)), forControlEvents: .TouchUpInside)
        
        let viewsDict = ["tableView" : tableView,
                         "audioView" : audioView,
                         "inputBar" : inputBar]
        let vflDict = ["H:|-0-[tableView]-0-|",
                       "V:|-[tableView]-0-[inputBar]",
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
        
        // audio: begin / interrupt / end / timeOut ...
        audioView.backgroundColor = UIColor.brownColor()
        inputBar.audioRecordBtn.begin = {[weak self] () -> Void in
            self?.audioView.hidden = false
            let audioName = NSUUID().UUIDString
            if let fileUrl = NSFileManager.yrAudioMessageURLWithName(audioName) {
                YRAudioService.defaultService.yr_beginRecordWithFileURL(fileUrl, audioDelegate: self!)
                YRAudioService.defaultService.recordTimeoutAction = {
                    
                    // timeOut action here
                    
                    YRAudioService.defaultService.startCheckRecordTimeoutTimer()
                    
                }
                YRAudioService.defaultService.startCheckRecordTimeoutTimer()
            }
        }
        inputBar.audioRecordBtn.end = {
            [weak self] () -> Void in

            YRAudioService.defaultService.shouldIgnoreStart = true
            guard YRAudioService.defaultService.audioRecorder?.currentTime > YRAudioService.AudioRecord.shortestDuration else {
                // too short
                print(" too short , cock!")
                return
            }
            
            self?.audioView.hidden = true
            YRAudioService.defaultService.endRecord()
            
            // interrupt Action here
            
            self?.sendAudioMessage()
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
        if let fileUrl = YRAudioService.defaultService.audioFileURL {
            let audioFile = AVFile(URL: fileUrl.absoluteString)
            let msg = AVIMImageMessage(text: "", file: audioFile, attributes: nil)
            print(" packed audio message done here: \(msg.mediaType)")

            //            insertAndSendConversation(msg)
        }
        
        // inset message and update ui from here

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
        self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: .Bottom, animated: true)
    }
    
    private func insertAndSendConversation(message: AVIMTypedMessage) {
        let lastSection = self.messages.count
        let set: NSIndexSet = NSIndexSet(index: lastSection)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        conversation?.sendMessage(message, callback: { [weak self] (success, error) in
            self?.tableView.beginUpdates()
            self?.messages.append(message)
            self?.tableView.insertSections(set, withRowAnimation: .Automatic)
            self?.tableView.endUpdates()
            CATransaction.commit()
            let bottomOffset = (self?.tableView.contentSize.height)! - (self?.tableView.contentOffset.y)!
            print(bottomOffset)
            self?.inputBar.textView.text = ""
            self?.inputBar.barHeightConstraint!.constant = 44.0;
            self?.tableView.contentOffset = CGPointMake(0, (self?.tableView.contentSize.height)! - bottomOffset);
            })
    }
    
    func didReciveMessage(notification: NSNotification) {
        if  let userInfo = notification.userInfo {
            let messageInfo = userInfo["info"] as! AVIMTypedMessage
//            print("recieve message notifed ~~~ \(messageInfo.ioType)")
            self.messages.append(messageInfo)
            self.tableView.reloadData()
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "notificationsRecieveMessage", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

//  MARK: -- Extension tableView --
extension YRConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let msg = self.messages[indexPath.section]
        
        if msg.ioType == AVIMMessageIOTypeOut {
            switch msg.mediaType {
            case -2:
                let cell = tableView.dequeueReusableCellWithIdentifier("YRRightImgCell", forIndexPath: indexPath) as! YRRightImgCell
                return cell
            case -1:
                let cell = tableView.dequeueReusableCellWithIdentifier("YRRightTextCell", forIndexPath: indexPath) as! YRRightTextCell
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("YRRightTextCell", forIndexPath: indexPath) as! YRRightTextCell
                cell.chatContentTextLb.text = msg.content
                return cell
            }
        }else {
            switch msg.mediaType {
            case -2:
                let cell = tableView.dequeueReusableCellWithIdentifier("YRLeftImgCell", forIndexPath: indexPath) as! YRLeftImgCell
                return cell
            case -1:
                let cell = tableView.dequeueReusableCellWithIdentifier("YRLeftTextCell", forIndexPath: indexPath) as! YRLeftTextCell
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("YRLeftTextCell", forIndexPath: indexPath) as! YRLeftTextCell
                cell.chatContentTextLb.text = msg.content
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = self.messages[section]
        let header = YRMessageHeaderView()
        header.timeLb.text = "\(model.sendTimestamp)"
        return header
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
}

//  MARK: -- Extension Keyboard --
extension YRConversationViewController {
    
    func notificationsKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShowOrHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func notificationsRecieveMessage() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.didReciveMessage(_:)), name: "YRClientDidReciveMessageNotification", object: nil)
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
        self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: .Bottom, animated: true)
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
    
//    func audioRecorderBeginInterruption(recorder: AVAudioRecorder) {
//        print(" interrupt ")
//    }
//    
//    func audioRecorderEndInterruption(recorder: AVAudioRecorder, withOptions flags: Int) {
//        <#code#>
//    }
}

// MARK: -- UIImagePickerControllerDelegate --
extension YRConversationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

