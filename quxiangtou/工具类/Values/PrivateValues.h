//
//  PrivateValues.h
//  EStickApp
//
//  Created by umina on 6/8/14.
//  Copyright (c) 2014 xyx. All rights reserved.
//
#define Private_CurKey @"PrivateCurKey"
#define firstKey @"first"
#define secKey   @"second"
#define thirdKey @"third"
#define forthKey @"forth"
#define fifthKey @"fifth"

#import <Foundation/Foundation.h>

@interface PrivateValues : NSObject
+(BOOL)initValuesForFirstLaunch;

+(BOOL)saveValue:(id)newValue forKey:(NSString*)key;
+(void)Delete:(NSString*)key;

+(id)getValueForKey:(NSString*)key;
+(id)getValueForPrivateModeKey:(NSString *)key;
+(BOOL)setCurrentUserKey:(NSString *)currentUserKey;
+(NSString *)currentUserKey;

+(BOOL)deleteAtIndex:(NSUInteger)index;
+(BOOL)saveValue:(id)newValue withName:(NSString *)name forKey:(NSString*)key;
+(BOOL)addValue:(id)newValue withName:(NSString *)name;
+(NSString *)getNameForKey:(NSString *)key;

+(NSString *)getStringKey:(NSString *)key;
+(NSArray *)getAllName;



@end
