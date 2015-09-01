//
//  HttpHelper.m
//  WeiBo
//
//  Created by alex  on 15/6/4.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper


//获取accessToken
+ (void)askAccess{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://www.baidu.com";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

//获得当前登录用户和朋友的最新微博
+ (NSArray *)statuses{
    NSArray *array;
    
    return array;
}
@end
