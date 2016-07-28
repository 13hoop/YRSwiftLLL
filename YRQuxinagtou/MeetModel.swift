//
//  MeetModel.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/27.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct MeetModel {    
    var meet: [Profile] = []
    init(fromJSONDictionary info: [String: AnyObject]) {
        if let obj = info["data"] as? [AnyObject] {
            meet = obj.map({ (item) -> Profile in
                
                print(" --- meetModel here ---")
                let info = item as? [String: AnyObject]
                let profile = Profile(fromJSONDictionary: info!)
                return profile
            })
        }
    }
}