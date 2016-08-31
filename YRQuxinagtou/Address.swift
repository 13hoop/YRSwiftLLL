//
//  Address.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/31.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct AddressList {
    var list: [Address] = []
    init(fromJSONDictionary info: [AnyObject]) {
        for addr in info {
            let address = Address(fromJSONDictionary: addr as! [String : AnyObject])
            list.append(address)
        }
    }
}

struct Address {
    var id: String?
    var consignee: String?
    var mobile: String?
    var province_id: String?
    var city_id: String?
    var district_id: String?
    var detailed: String?
    var full: String?
    var is_default: String?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        if  let id = info["id"] as? String,
            let consignee = info["consignee"] as? String,
            let mobile = info["mobile"] as? String?,
            let province_id = info["province_id"] as? String?,
            let city_id = info["city_id"] as? String?,
            let district_id = info["district_id"] as? String?,
            let detailed = info["detailed"] as? String?,
            let full = info["full"] as? String?,
            let is_default = info["is_default"] as? String? {
            
            self.id = id
            self.consignee = consignee
            self.mobile = mobile
            self.province_id = province_id
            self.city_id = city_id
            self.district_id = district_id
            self.detailed = detailed
            self.full = full
            self.is_default = is_default
        }
    }
}