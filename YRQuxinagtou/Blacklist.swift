//
//  Blacklist.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/23.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct Blacklist {
    var uuid: String?
    var nickname: String?
    var avatar: String?
    var created_at: String?

    init(fromJSONDictionary info: [String: AnyObject]) {
        
        if  let uuid = info["uuid"] as? String,
        let nickname = info["nickname"] as? String,
        let avatar = info["avatar"] as? String?,
        let created_at = info["created_at"] as? String? {
            self.uuid = uuid
            self.nickname = nickname
            self.avatar = avatar
            self.created_at = created_at
        }
    }
}