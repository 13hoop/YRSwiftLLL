//
//  CoreData.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/9.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import CoreData


// context can set and get
protocol ManagedObjectContextSettable: class {
      var managedObjectContext : NSManagedObjectContext! { get set }
}

public func createYRMainContext() -> NSManagedObjectContext {
    
    // 1 Model: get managed object model that resided from bundle
    guard let modelURL = NSBundle.mainBundle().URLForResource("YRChatListModel", withExtension: "momd") else {
        fatalError("Error in loading model from bundle")
    }
    guard let model = NSManagedObjectModel(contentsOfURL: modelURL) else {
        fatalError("initializing mom error from \(modelURL)")
    }
  
    // 2 Creat PSC: ulr points to .yongren file and SQL file
    let storeURL = NSURL.documentsURL.URLByAppendingPathComponent("YRPrivatStore.yongren")
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    do {
        try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
    }catch {
        // if you change the ".xcdatamodeld"
        fatalError(" migrating store SQL file error:\(error) ")
    }
    
    //
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}

