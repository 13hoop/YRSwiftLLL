//
//  PRLColor.h
//  quxiangtou
//
//  Created by wei feng on 15/8/10.
//  Copyright (c) 2015年 蒲瑞玲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRLColor : UIColor

+(UIColor *)colorWithHexadecimalRGB:(NSString *)RGBString;
+(UIColor *)colorWithHexadecimalRGB:(NSString *)RGBString alpha:(float)alpha;

@end

UIColor * color(int R,int G,int B);
UIColor * color_alpha(int R,int G,int B,float alpha);
