//
//  CASegmentedControl.h
//  PalmCar4S
//
//  Created by libingting on 14-9-3.
//  Copyright (c) 2014年 PalmCar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CASegmentedControl;
@protocol CASegmentedControlDelegate <NSObject>
-(void)segmentedControl:(CASegmentedControl *)control index:(NSInteger)index;
@end

@interface CASegmentedControl : UIView
+(CASegmentedControl *)titles:(NSArray *)array delegate:(id)my;
@property (nonatomic,weak) id<CASegmentedControlDelegate> delegate;
@end

