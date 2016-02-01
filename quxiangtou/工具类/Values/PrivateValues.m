//
//  PrivateValues.m
//  EStickApp
//
//  Created by umina on 6/8/14.
//  Copyright (c) 2014 xyx. All rights reserved.
//

#import "PrivateValues.h"



@implementation PrivateValues
+(BOOL)initValuesForFirstLaunch{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    //判断是否以创建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        //初始化文件
        NSMutableDictionary *appList = [[NSMutableDictionary alloc ] init];
        [appList setObject:@"0" forKey:PLIST_VALUE_INTENSITY];  //强度控制中的数值
        
        if ([appList writeToFile:plistPath atomically:YES]) {
            return YES;
        }
    }
    return NO;
}

+(BOOL)saveValue:(id)newValue withName:(NSString *)name forKey:(NSString*)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    //储值
    NSMutableDictionary *myValuesList = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] mutableCopy];
    
    //B150707001 Andy - 下面if判斷式內容一樣，整理後移到這．
    NSDictionary *new_private = @{@"value": newValue, @"name" : name, @"Type" : @"1"};
    [myValuesList setObject:new_private forKey:key];
    return [myValuesList writeToFile:plistPath atomically:YES];
    
    //[myValuesList setObject:newValue forKey:key];
    
    //B150707001 Andy - remark
    //    if(newValue) {
    //        NSDictionary *new_private = @{@"value": newValue,@"name" : name,@"Type" : @"1"};
    
    //        [myValuesList setObject:new_private forKey:key];
    
    //        return [myValuesList writeToFile:plistPath atomically:YES];
    
    //    } else {
    //        NSDictionary *new_private = @{@"value": newValue,@"name" : name,@"Type" : @"1"};
    
    //        [myValuesList setObject:new_private forKey:key];
    
    //        return [myValuesList writeToFile:plistPath atomically:YES];
    //    }
}

+(BOOL)addValue:(id)newValue withName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    //储值
    NSMutableDictionary *myValuesList = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    NSArray *keys = @[firstKey,secKey,thirdKey,forthKey,fifthKey];
    
    NSArray *values = [myValuesList objectsForKeys:keys notFoundMarker:@"0"];
    
    int count = 0;
    for(id obj in values)
    {
        if(![obj isEqual:@"0"])
        {
            //捕获到全部储存完毕
            if(count == 4)
            {
                NSMutableArray *values_copy = [[NSMutableArray alloc]initWithArray:[values objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 4)]] copyItems:YES ];
                [values_copy addObject:@{@"value": newValue,@"name" : name,@"Type" : @"1"}];
                
                int count = 0;
                for(id key in keys)
                {
                    [myValuesList setObject:[values_copy objectAtIndex:count] forKey:key];
                    count++;
                }
                
                return [myValuesList writeToFile:plistPath atomically:YES];
            }
        }
        else
        {
            [myValuesList setObject:@{@"value": newValue,@"name" : name,@"Type" : @"1"} forKey:[keys objectAtIndex:count]];
            break;
        }
        count++;
    }
    
    return [myValuesList writeToFile:plistPath atomically:YES];
}

+(BOOL)deleteAtIndex:(NSUInteger)index{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    //储值
    NSMutableDictionary *myValuesList = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    NSArray *keys = @[firstKey,secKey,thirdKey,forthKey,fifthKey];
    
    [myValuesList setObject:@"0" forKey:[keys objectAtIndex:index]];
    
    //14.字典将某个特定的数组作为key值传进去得到对应的value，如果某个key找不到对应的key，就用notFoundMarker提前设定的值代替
    NSArray *values = [myValuesList objectsForKeys:keys notFoundMarker:@"0"];
    
    NSMutableArray *founds = [[NSMutableArray alloc] init];
    
    for(id value in values)
    {
        if(![value isEqual:@"0"])
        {
            [founds addObject:value];
        }
    }
    
    for(int i = 0;i<5;i++)
    {
        if(i<=([founds count]-1) && [founds count] > 0)
            [myValuesList setObject:[founds objectAtIndex:i] forKey:[keys objectAtIndex:i]];
        else
        {
            [myValuesList setObject:@"0" forKey:[keys objectAtIndex:i]];
        }
    }
    
    return [myValuesList writeToFile:plistPath atomically:YES];
}

+(BOOL)saveValue:(id)newValue forKey:(NSString*)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    //储值
    NSMutableDictionary *myValuesList = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    [myValuesList setObject:newValue forKey:key];
    
    if ([myValuesList writeToFile:plistPath atomically:YES]) {
        return YES;
    }
    else{
        return NO;
    }
}

+(void)Delete:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    NSMutableDictionary *myValuesList = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    [myValuesList removeObjectForKey:key];
    
    [myValuesList writeToFile:plistPath atomically:YES];
}

+(BOOL)setCurrentUserKey:(NSString *)currentUserKey
{
    [[NSUserDefaults standardUserDefaults] setObject:currentUserKey forKey:Private_CurKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)currentUserKey{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Private_CurKey];
}
+(NSString *)getNameForKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    NSDictionary *myValuesList = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    NSDictionary *private = [myValuesList objectForKey:key];
    
    if([[myValuesList allKeys] containsObject:key])
    {
        NSString *name = [private objectForKey:@"name"];
        
        return name;
    }
    
    return nil;
}

+(id)getValueForKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    NSDictionary *myValuesList = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    id result = [myValuesList objectForKey:key];
    return result;
}

+(id)getValueForPrivateModeKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    NSDictionary *myValuesList = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    NSDictionary * private = [myValuesList objectForKey:key];
    
    return private[@"value"];
}

+(NSString *)getStringKey:(NSString *)key{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    NSDictionary *myValuesList = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    return myValuesList[key];
}
+(NSArray *)getAllName{
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"MyValues.plist"];
    
    NSDictionary *myValuesList = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    NSArray *keys = @[firstKey,secKey,thirdKey,forthKey,fifthKey];
    
    
    for(NSString *key in keys)
    {
        id obj = [myValuesList objectForKey:key];
        if([obj isKindOfClass:[NSDictionary class]])
        {
            [arr addObject:obj[@"name"]];
        }
    }
    
    return arr;
}
@end
