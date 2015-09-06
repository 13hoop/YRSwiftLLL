//
//  ACommenData.m
//  Matchmaker_LYBT
//
//  Created by mac on 14-2-15.
//  Copyright (c) 2014年 蒲瑞玲. All rights reserved.
//

#import "ACommenData.h"

static ACommenData *class=nil;
@implementation ACommenData
@synthesize logDic,regDic;

+(ACommenData *)sharedInstance{
    if(class==nil){
        class=[[ACommenData alloc]init];
    }
    return class;
}
@end
