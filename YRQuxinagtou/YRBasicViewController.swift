//
//  YRBasicViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/9/12.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRBasicViewController: UIViewController, AVIMClientDelegate {

    var client: AVIMClient?
    override func viewDidLoad() {
        super.viewDidLoad()
        openChat()
    }
    
    private func openChat() {
        let uuid = YRUserDefaults.userUuid
        let nickName = uuid
        let chatWithName =  uuid == "e514zVWqnM" ? "QklVO4Oqw9" : "e514zVWqnM"
        self.client = AVIMClient(clientId: chatWithName)
        client?.delegate = self
        self.client?.openWithCallback({ (success, error) in
            print("~~~~~~ ~~~~ successs: \(success) and error \(error)")
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

