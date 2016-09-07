//
//  Diamonds.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/9/7.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

struct Diamonds {
    var list: [Product] = []
    init(fromJSONDictionary info: [String: AnyObject]) {
        if let item = info["items"] as? [AnyObject] {
            for addr in item {
                let item = Product(fromJSONDictionary: addr as! [String : AnyObject])
                list.append(item)
            }
        }
    }
}

struct Product {
    
    var id: String?
    var name: String?
    var quantity: String?
    var price: String?
    
    init(fromJSONDictionary info: [String: AnyObject]) {
        if  let id = info["id"] as? String,
            let name = info["name"] as? String,
            let quantity = info["quantity"] as? String?,
            let price = info["price"] as? String? {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.price = price
        }
    }
}