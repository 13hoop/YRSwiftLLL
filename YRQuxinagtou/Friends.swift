//
//  Friends.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/26.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct Friends {
    var next_page: Int?
    var hasNextPage: Bool = false
    var list: [FriendOne] = [FriendOne]()
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        if  let next_page = info["next_page"] as? Int?,
        let arr = info["list"] as? [AnyObject]
        {
            self.next_page = next_page
            self.hasNextPage = next_page == 0 ? false : true
            for obj in arr {
                let oneFriend = FriendOne(fromJSONDictionary: obj as! [String: AnyObject])
                self.list.append(oneFriend)
            }
        }
    }
}

struct FriendOne {
    var uuid: String?
    var nickname: String?
    var avatar: String?

    var online: String?
    var isOnline: Bool = false
    var certificate_icon: Bool = false
    var connection_icon: String?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        if  let uuid = info["uuid"] as? String?,
            let nickname = info["nickname"] as? String?,
            let avatar = info["avatar"] as? String?,
            let online = info["online"] as? String?,
            let certi = info["certificate_icon"] as? Bool,
            let connect = info["connection_icon"] as? String? {
            
            self.uuid = uuid
            self.nickname = nickname
            self.avatar = avatar
            self.online = online
            self.isOnline = online == "offline" ? false : true
            self.certificate_icon = certi
            self.connection_icon = connect
        }
    }
}
