//
//  DataSourceHelper.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/19.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

// wait ... todo


//class YRCollectionViewDataSource<Delegate: DataSourceDelegate, Data: DataProvider, Cell: ConfigurableCell, Cell.DataSource == Data.Object>: NSObject, UICollectionViewDataSource {
//    
//    private let collectionView: UICollectionView
//    private let dataProvider: Data
//    private weak var delegate: Delegate!
//    required init(collectionView: UICollectionView, dataProvider: Data, delegate: Delegate) {
//        self.collectionView = collectionView
//        self.dataProvider = dataProvider
//        self.delegate = delegate
//        super.init()
//        collectionView.delegate = self
//        collectionView.reloadData()
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataProvider.numberOfItemsInSection(section)
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let object = dataProvider.objectAtIndexPath(indexPath)
//        let identifier = delegate.cellIdentifierForObject(object)
//    }
//}
