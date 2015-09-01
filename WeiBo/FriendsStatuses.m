//
//  FriendsStatuses.m
//  WeiBo
//
//  Created by alex  on 15/6/4.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "FriendsStatuses.h"

@implementation FriendsStatuses
@synthesize statuses;
- (FriendsStatuses *)initWithURL:(NSURL *)url
{
    statuses = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *rootStatues = [rootDic objectForKey:@"statuses"];
    for(NSDictionary *dic in rootStatues)
    {
        Statuses *stat = [[Statuses alloc] initWithDictionary:dic];
        NSDictionary *retweetedDictionary = [dic objectForKey:@"retweeted_status"];
        Statuses *retweeted_status = [[Statuses alloc] initWithDictionary:retweetedDictionary];
        NSArray *s = [NSArray arrayWithObjects:stat,retweeted_status,nil];
        [statuses addObject:s];
    }
    return self;
}
@end
