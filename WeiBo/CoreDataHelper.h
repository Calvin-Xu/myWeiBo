//
//  CoreDataHelper.h
//  WeiBo
//
//  Created by alex  on 15/6/4.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
@interface CoreDataHelper : NSObject

+ (NSString *)queryAccess;
+ (void)del;
+ (void)insert:(NSString *)accessToken;
+ (void)updateAccess:(NSString *)oldAccessToken newAccessToken:(NSString *)newAccess;
@end
