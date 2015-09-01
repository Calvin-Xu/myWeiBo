//
//  Statuses.m
//  WeiBo
//
//  Created by alex  on 15/6/19.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "Statuses.h"

@implementation Statuses
@synthesize created_at,text,idstr,source,thumbnail_pic,bmiddle_pic,original_pic,favorited;
@synthesize user;

- (Statuses *)initWithDictionary:(NSDictionary *)dictionary    //初始化Statuses实例
{
    self.created_at = [dictionary objectForKey:@"created_at"];
    self.comments_count = [dictionary objectForKey:@"comments_count"];
    self.attitudes_count = [dictionary objectForKey:@"attitudes_count"];
    self.favorited = [dictionary objectForKey:@"favorited"];
    self.text = [dictionary objectForKey:@"text"];
    self.idstr = [dictionary objectForKey:@"idstr"];
    self.reposts_count = [dictionary objectForKey:@"reposts_count"];
    self.source = [dictionary objectForKey:@"source"];
    NSArray *pic = [dictionary objectForKey:@"pic_urls"];
    self.thumbnail_pic = [[NSMutableArray alloc] init];
    for (NSDictionary *p in pic) {
        NSString *s = [p objectForKey:@"thumbnail_pic"];
        [self.thumbnail_pic addObject:s];
    }
    NSDictionary *us = [dictionary objectForKey:@"user"];
    user = [[User alloc]initWithDictionary:us];
    return self;
}
@end
