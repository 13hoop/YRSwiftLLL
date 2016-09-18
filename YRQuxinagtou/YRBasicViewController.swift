//
//  YRBasicViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/9/12.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import RealmSwift
import AVOSCloudIM

class YRBasicViewController: UIViewController, AVIMClientDelegate {

    var client: AVIMClient?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        openChat()
    }
    
    private func openChat() {
        let uuid = YRUserDefaults.userUuid
//        let nickName = uuid
        let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
        self.client = AVIMClient(clientId: chatWithName)
        client?.delegate = self
        self.client?.openWithCallback({ (success, error) in
            print("~~~~~~ ~~~~ successs: \(success) and error \(error)")
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func conversation(conversation: AVIMConversation!, didReceiveUnread unread: Int) {
        print(" 未读消息数目：\(unread)")
        guard unread > 0 else {
            return
        }
    }
    
    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        print(message)
        
        
        print("   in  basic view controller ...   ")
        
        let uuid = conversation.clientId
        let date = conversation.lastMessageAt
        print("\(conversation.clientId) --\(date) and \(message.text)")

        let results = realm.objects(YRChatModel).filter(" uuid = '\(uuid)'")
        print(results)
        
        guard results.count > 0 else { return }
        if let model = results.last {
            realm.beginWrite()
            model.lastText = "aaaaaaa"
            model.imgStr = "xmeise.com"
            try! realm.commitWrite()
            print("update: \(model)")
        }
    }
}

