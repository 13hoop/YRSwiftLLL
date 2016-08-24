//
//  Filters.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/24.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct Filters {
    var gender: String?
    var city: String?
    var purpose: String?
    var age_min: String?
    var age_max: String?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        if  let gender = info["gender"] as? String,
            let city = info["city"] as? String,
            let purpose = info["purpose"] as? String?,
            let age_min = info["age_min"] as? String?,
            let age_max = info["age_max"] as? String? {

            self.gender = gender
            self.city = city
            self.purpose = purpose
            self.age_max = age_max
            self.age_min = age_min
        }
    }
}