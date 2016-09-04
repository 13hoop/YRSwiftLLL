//
//  YRDelayHelp.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/9/2.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import Foundation

typealias YRTask = (cancel : Bool) -> Void
func yr_Delay(time: NSTimeInterval, task: ()-> ()) -> YRTask? {
    func dispatch_later(block: () -> ()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
    }
    
    let closure: dispatch_block_t? = task
    var result: YRTask?
    
    let delayedClosure: YRTask = {
        cancel in
        if let internalClosure = closure {
            if cancel == false {
                dispatch_async(dispatch_get_main_queue(), internalClosure)
            }
        }
    }
    
    result = delayedClosure
    
    dispatch_later { 
        if let delayedClosure = result {
            delayedClosure(cancel: false)
        }
    }
    return result
}

func yr_Cancel(task: YRTask?) {
    task?(cancel: true)
}
