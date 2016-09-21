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
//        let nickName = uuid
        let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
        self.client = AVIMClient(clientId: chatWithName)
        client?.delegate = self
        self.client?.openWithCallback({ (success, error) in
            print("~~~~~~ ~~~~ successs: \(success) and error \(error)")
            
            // query recently conversation -- not work well
//            let query = self.client?.conversationQuery()
//            query?.limit = 20
//            query?.findConversationsWithCallback({ (conversations, error) in
//                guard error == nil else {
//                    return
//                }
//                self.findedConversations = conversations
//                print(conversations)
//                let cc = self.findedConversations[0] as! AVIMConversation
//                print("\(cc.name) -  \(cc.attributes) - \(cc.conversationId)")
//            })
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
        print(message)
        

        let uuid = conversation.clientId
        let date = conversation.lastMessageAt

        // bebug
        print("   in  basic view controller ...   ")
        print("\(conversation.clientId) --\(date) and \(message.text)")

        let results = realm.objects(YRChatModel).filter(" uuid = '\(uuid)'")
        print(results)
        
        guard results.count > 0 else {
        
            // new here
            let model = YRChatModel()
            model.converstationID = conversation.conversationId
            model.uuid = uuid
            addToRealm(model)
            
            return
        }
        
        // old friend
        if let model = results.last {
            realm.beginWrite()
            model.lastText = "aaaaaaa"
            model.imgStr = "xmeise.com"
            
            let num = Int(model.numStr)
            model.numStr = "\(num! + 1)"
            try! realm.commitWrite()
            print("update: \(model)")
        }
    }
}

