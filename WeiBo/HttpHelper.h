//
//  HttpHelper.h
//  WeiBo
//
//  Created by alex  on 15/6/4.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "AccessToken.h"
@interface HttpHelper : NSObject

+ (void)askAccess;

+ (NSArray *)statuses;
@end
