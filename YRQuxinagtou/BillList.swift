//
//  BillList.swift
//  YRQuxinagtou
//
//  Created by YongRen on 2016/10/16.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct BillList {
    var quantity: String?
    var created_at: String?
    var action: String?
    var type: String?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        if  let quantity = info["quantity"] as? Int?,
            let created_at = info["created_at"] as? String,
            let action = info["action"] as? String?,
            let type = info["type"] as? String? {
            self.quantity = String(quantity)
            self.type = type
            self.action = action
            self.created_at = created_at
        }
    }
}
