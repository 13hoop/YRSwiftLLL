//
//  YRMeessage+CoreDataProperties.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/19.
//  Copyright © 2016年 YongRen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension YRMeessage {

    @NSManaged var content: String?
    @NSManaged var status: NSNumber?
    @NSManaged var messageTime: String?
    @NSManaged var userEntity: YRChatUser?

}
