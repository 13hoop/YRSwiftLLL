//
//  YRMessageViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YRMessageViewController: UIViewController {
    
    
    // updates data : chat user list data
//    var updates
    
    var client: AVIMClient?
    private let defaultTitles = ["访客", "配对" , "最爱"]
    private let defaultInfo = ["看看最近谁来过", "与你互相喜欢的会员", "看看最爱"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        print("  😼 😼 😼 😼 😼 😼  ")
        openChat()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func openChat() {
        let uuid = YRUserDefaults.userUuid
        let nickName = uuid
        let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
        self.client = AVIMClient(clientId: chatWithName)
        client?.delegate = self
//        self.client?.openWithCallback({ (success, error) in
//            print("~~~~~~ ~~~~ successs: \(success) and error \(error)")
//        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if tabBarController?.tabBar.hidden == true {
           tabBarController?.tabBar.hidden = false
        }
    }
    private func setUpView() {
        
        layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .Vertical
        layout?.minimumLineSpacing = 0.0
        layout?.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 76)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let viewsDict = ["collectionView" : collectionView]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-0-[collectionView]-0-|"]
        for obj in vflDict {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(obj as String, options: [], metrics: nil, views: viewsDict))
        }
    }
    
    private var layout: UICollectionViewFlowLayout?
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(YRChartListCell.self, forCellWithReuseIdentifier: "YRChartListCell")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .whiteColor()
        return collectionView
    }()
}

//MARK: collectionViewDataSource
extension YRMessageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:   NSIndexPath) {

        if indexPath.item < 3 {
            let vc = YRConectViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = YRConversationViewController()
            let uuid = YRUserDefaults.userUuid
            let nickName = uuid
            
            let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
            
            self.client = AVIMClient(clientId: nickName)
            client?.delegate = self
            client!.delegate = vc
            client!.openWithCallback { (succeede, error) in
                if (error == nil) {
                    self.client!.createConversationWithName("\(nickName)与\(chatWithName)的对话", clientIds: [chatWithName], callback: {[weak vc] (conversation, error) in
                        vc?.conversation = conversation
                        })
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    let alertView: UIAlertView = UIAlertView(title: "聊天不可用！", message: error?.description, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = cell as? YRChartListCell {
            if indexPath.item < 3 {
                cell.imgV.backgroundColor = YRConfig.systemTintColored
                cell.titleLb.text = self.defaultTitles[indexPath.row]
                cell.infoLb.text = self.defaultInfo[indexPath.row]
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + 3;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRChartListCell", forIndexPath: indexPath)
        return cell
    }
}

extension YRMessageViewController: AVIMClientDelegate {


    func conversation(conversation: AVIMConversation!, didReceiveUnread unread: Int) {
        print(" 未读消息数目：\(unread)")
        guard unread > 0 else {
            return
        }
        
        conversation.queryMessagesFromServerWithLimit(1, callback: {
            (objs, error) in
            print(error)
        })
    }
    
    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        print(message)
    }
}




