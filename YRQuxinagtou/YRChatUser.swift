//
//  YRChatUser.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/19.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation
import CoreData

@objc(YRChatUser)
class YRChatUser: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension YRChatUser: ManagedObjectType {
    internal static var entityName: String {
        return "YRChatUser"
    }
    
    internal static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending:  false)]
    }
}
