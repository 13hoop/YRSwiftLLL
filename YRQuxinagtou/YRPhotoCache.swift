//
//  YRPhotoCache.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/15.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation
import Photos


// do not used 
final class YRPhotoCache {

    var cachePreheatSize: Int
    var imageCache: PHCachingImageManager
    var imageAssets: PHFetchResult
    var targetSize = CGSize(width: 80, height: 80)
    var contentMode = PHImageContentMode.AspectFill
    
    private var cacheIndices = NSIndexSet()
    init(manager: PHCachingImageManager, imageAssets: PHFetchResult, preheatSize: Int = 1) {
        self.cachePreheatSize = preheatSize
        self.imageCache = manager
        self.imageAssets = imageAssets
    }
    
    // not very good --XXXXX
    func updateVisibleCell(cellPaths : [NSIndexPath]) {
        
        guard !cellPaths.isEmpty else { return }
        
        let updatedCache = NSMutableIndexSet()
        for path in cellPaths {
            updatedCache.addIndex(path.item)
        }
        
        let minCache = max(0, updatedCache.firstIndex - cachePreheatSize)
        let maxCache = min(imageAssets.count - 1, updatedCache.lastIndex + cachePreheatSize)
        
        updatedCache.addIndexesInRange(NSMakeRange(minCache, maxCache - minCache + 1))
        
        self.cacheIndices.enumerateIndexesUsingBlock { (index, _) in
            if !self.cacheIndices.containsIndex(index) {
                let asset: PHAsset = self.imageAssets[index] as! PHAsset
                self.imageCache.startCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: nil)
            }
        }
        
        self.cacheIndices.enumerateIndexesUsingBlock { (index, _) in
            if !self.cacheIndices.containsIndex(index) {
                let asset: PHAsset = self.imageAssets[index] as! PHAsset
                self.imageCache.stopCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: nil)
            }
        }
        
        cacheIndices = NSIndexSet(indexSet: updatedCache)
        
    }
    
}