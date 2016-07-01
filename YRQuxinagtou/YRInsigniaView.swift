//
//  YRInsigniaView.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/23.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

enum YRInsigniaStyle: String {
    case authentication = "authentication"
    case insignia = "insignia"
}

private struct YRSize {
    static let width: CGFloat = UIScreen.mainScreen().bounds.width / 5
}

class YRInsigniaView: UIScrollView {
    
    convenience init(frame: CGRect,insignStyle style: YRInsigniaStyle) {
        self.init(frame: frame)
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        decelerationRate = UIScrollViewDecelerationRateFast
        setUpViews(insignStyle: style)
    }
    
    private func setUpViews(insignStyle style: YRInsigniaStyle) {
        switch style {
        case .authentication:
            
            for index in 0 ... 4 {
                let view = UIView(frame: CGRectMake(CGFloat(index) * YRSize.width, 0, YRSize.width, 102))
                view.backgroundColor = UIColor.randomColor()
                addSubview(view)
            }
        case .insignia:
            
            contentSize = CGSizeMake(8 * YRSize.width, 0)
            for index in 0 ... 8 {
                let view = UIView(frame: CGRectMake(CGFloat(index) * YRSize.width, 0, YRSize.width, 102))
                view.backgroundColor = UIColor.randomColor()
                addSubview(view)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}