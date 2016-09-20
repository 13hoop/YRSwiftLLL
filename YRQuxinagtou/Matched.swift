//
//  Matched.swift
//  YRQuxinagtou
//
//  Created by Meng Ye on 16/9/13.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct Matched {
    var next_page: Int?
    var hasNextPage: Bool = false
    var list: [MatchedOne] = [MatchedOne]()
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        if  let next_page = info["next_page"] as? Int?,
        let arr = info["list"] as? [AnyObject]
        {
            self.next_page = next_page
            self.hasNextPage = next_page == 0 ? false : true
            for obj in arr {
                let one = MatchedOne(fromJSONDictionary: obj as! [String: AnyObject])
                self.list.append(one)
            }
        }
    }
}

struct MatchedOne {
    var uuid: String?
    var nickname: String?
    var avatar: String?
    var online: String?
    var isOnline: Bool = false
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        if  let uuid = info["uuid"] as? String? {
            let nickname = info["nickname"] as! String!
            let avatar = info["avatar"] as! String!
            let online = info["online"] as? String?
        
            self.uuid = uuid
            self.nickname = nickname
            self.avatar = avatar
            self.online = online!
            self.isOnline = self.online == "available" ? true : false
        }
    }
}
