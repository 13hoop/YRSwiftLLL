//
//  MyEditViewController.h
//  quxiangtou
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeMessageDelegate <NSObject>

-(void)giveGender:(NSNumber *)gender Gexual_frequencyString:(NSString *)sexual_frequencyNumber Sexual_durationString:(NSNumber *)sexual_durationNumber Sexual_orientationString:(NSNumber *)sexual_orientationNumber Sexual_positionString:(NSNumber *)sexual_positionNumber;

@end
@interface MyEditViewController : UIViewController
{
    ASIFormDataRequest * updataMessageRequest;
}
@property (nonatomic,strong) NSNumber * genderNumber;
@property (nonatomic,strong) NSString * sexual_frequencyString;
@property (nonatomic,strong) NSNumber * sexual_durationNumber;
@property (nonatomic,strong) NSNumber * sexual_orientationNumber;
@property (nonatomic,strong) NSNumber * sexual_positionNumber;
@property (nonatomic,assign) id<changeMessageDelegate>delegate;
@end
