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
    var want_gender: String?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        
        if  let age_min = info["age_min"] as? String?,
            let age_max = info["age_max"] as? String? {
            self.age_max = age_max
            self.age_min = age_min
        }
        if let city = info["city"] as? String? {
            self.city = city
        }
                
        if let gender = info["gender"] as? String? {
            self.gender = gender
        }

        if let purpose = info["purpose"] as? String? {
            self.purpose = purpose
        }
        
        if let want_gender = info["want_gender"] as? String? {
            self.want_gender = want_gender
        }
    }
}
