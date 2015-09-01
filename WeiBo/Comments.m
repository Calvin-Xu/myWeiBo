//
//  Comment.m
//  WeiBo
//
//  Created by xhj on 15/7/24.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "Comments.h"

@implementation Comments
@synthesize comments;
- (Comments *)initWithURL:(NSURL *)url
{
    self.comments = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    self.total = [rootDic objectForKey:@"total_number"];
    NSArray *rootStatues = [rootDic objectForKey:@"comments"];
    for(NSDictionary *dic in rootStatues)
    {
        Comment *comment = [[Comment alloc] initWithDictionary:dic];
        [self.comments addObject:comment];
    }
    return self;
}

@end


@implementation Comment

- (Comment *)initWithDictionary:(NSDictionary *)dictionary    //初始化Statuses实例
{
    self.created_at = [dictionary objectForKey:@"created_at"];
    self.idStr = [dictionary objectForKey:@"idstr"];
    self.text = [dictionary objectForKey:@"text"];
    self.source = [dictionary objectForKey:@"source"];
    NSDictionary *us = [dictionary objectForKey:@"user"];
    self.user = [[User alloc]initWithDictionary:us];
    return self;
}


@end

