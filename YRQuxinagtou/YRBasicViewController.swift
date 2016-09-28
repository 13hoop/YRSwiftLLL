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
    var findedConversations = []
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        openChat()
    }
    
    private func openChat() {
        let uuid = YRUserDefaults.userUuid
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
    
    
    func addToRealm(model: YRChatModel) {
        try! self.realm.write({
            self.realm.add(model, update: true)
        })
    }
    
    
    func conversation(conversation: AVIMConversation!, didReceiveUnread unread: Int) {
        guard unread > 0 else {
            return
        }
        print(" 未读消息数目：\(unread)")
    }
    
    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("YRClientDidReciveMessageNotification", object: self, userInfo: ["info": message])
        
        let uuid = conversation.creator
        let date = conversation.lastMessageAt

        // bebug
        print("   in  basic view controller ...   ")
        print("\(conversation.clientId) --\(date) and \(message.text)")

        let results = realm.objects(YRChatModel).filter(" uuid = '\(uuid)'")
        print(results)
        
        guard results.count > 0 else {
            print(" new chat, creat by\(conversation.creator) ")
            // new here
            let model = YRChatModel()
            model.uuid = conversation.creator
            model.converstationID = conversation.conversationId
            
            addToRealm(model)
            return
        }
        
        // old friend
        if let model = results.last {
            realm.beginWrite()
            model.lastText = message.text
            let dateStr = "\(message.sendTimestamp)"
            model.time = dateStr
            let num = Int(model.numStr)
            model.numStr = "\(num! + 1)"
            try! realm.commitWrite()
            print("update: \(model)")
        }
    }
}

