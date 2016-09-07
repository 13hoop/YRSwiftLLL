//
//  YRCoredataHelper.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/18.
//  maybe hard for beginner, QQ: 9124531142
//  Copyright © 2016年 YongRen. All rights reserved.
//
import Foundation
import CoreData




// MARK: ---- ManagedObject in swift <--> NSManagedObject -----
public class ManagedObject: NSManagedObject {

}

// just using to simplify model class, keep code easy to maintain
public protocol ManagedObjectType: class {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}
// default implementation protocal in Swift’s protocol extensions
extension ManagedObjectType {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}





// MARK: ---- FetchedResultsDataProvider -----
class FetchedResultsDataProvider<Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate {
    
    // T
    typealias Object = Delegate.Object
    
    private var fetchedResultsController: NSFetchedResultsController
    private weak var delegate: Delegate!
    private var updates: [DataProviderUpdate<Object>] = []
    
    init(fetchedResultController: NSFetchedResultsController, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultController
        self.delegate = delegate
        super.init()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        }catch {
            fatalError(" dataProvider can not performFetch error: /n \(error)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        print(#function)

    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print(#function)

    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate.dataProviderDidUpdate(updates)
        print(#function)
    }

}

// ??? 是为了接管dataSource，暂时可以不用
protocol DataProvider: class {
    associatedtype Object // 可以是任意的类型
    // 得到具体的model
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object
    // section
    func numberOfItemsInSection(section: Int) -> Int
}

protocol DataProviderDelegate: class {
    associatedtype Object
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}

enum DataProviderUpdate<Object> {
    case Insert(NSIndexPath)
    case Update(NSIndexPath, Object)
    case Move(NSIndexPath, NSIndexPath)
    case Delete(NSIndexPath)
}

// MARK: config cell protocol
protocol YRCellConfigurabled {
    associatedtype ModelData
    func configuireForData(data: ModelData)
}




// MARK: *** class extension ***
extension NSURL {
    static var documentsURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
}
