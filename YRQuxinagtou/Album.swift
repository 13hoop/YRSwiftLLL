//
//  Album.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/24.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct Album {
    
    var next_page: Int?
    var hasNextPage: Bool = false
    var list: [AlbumInfo] = [AlbumInfo]()
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        if let next_page = info["next_page"] as? Int,
           let list = info["list"] as? [AnyObject]
        {
            self.next_page = next_page
            self.hasNextPage = self.next_page == 0 ? false : true
            for obj in list {
                let detail = AlbumInfo(fromJSONDictionary: obj as! [String: AnyObject])
                self.list.append(detail)
            }
        }
    }
}

struct AlbumInfo {
    var url: String?
    var md5: String?
    var status: String?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        if let url = info["url"] as? String,
           let md5 = info["md5"] as? String,
           let status = info["status"] as? String
        {
            self.url = url
            self.md5 = md5
            self.status = status
        }
    }
}