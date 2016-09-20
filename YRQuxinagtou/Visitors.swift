//
//  Visitors.swift
//  YRQuxinagtou
//
//  Created by Meng Ye on 16/9/12.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct Visitors {
    var next_page: Int?
    var hasNextPage: Bool = false
    var list: [VisitorOne] = [VisitorOne]()
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        if  let next_page = info["next_page"] as? Int?,
        let arr = info["list"] as? [AnyObject]
        {
            self.next_page = next_page
            self.hasNextPage = next_page == 0 ? false : true
            for obj in arr {
                let oneVisitor = VisitorOne(fromJSONDictionary: obj as! [String: AnyObject])
                self.list.append(oneVisitor)
            }
        }
    }
}

struct VisitorOne {
    var uuid: String?
    var nickname: String?
    var avatar: String?
    var online: String?
    var isOnline: Bool = false
    
    var visited_at: String?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        if  let uuid = info["uuid"] as? String?,
            let nickname = info["nickname"] as? String?,
            let avatar = info["avatar"] as? String?,
            let online = info["online"] as? String? {
            let visited_at = info["created_at"] as! String!
        
            self.uuid = uuid
            self.nickname = nickname
            self.avatar = avatar
            self.online = online
            self.isOnline = online == "available" ? true : false
            self.visited_at = visited_at
        }
    }
}
