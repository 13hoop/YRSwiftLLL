//
//  YRAuthViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/7/11.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRAuthViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension YRAuthViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("authSBcell", forIndexPath: indexPath)
        return cell
    }
}
