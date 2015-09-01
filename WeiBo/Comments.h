//
//  Comment.h
//  WeiBo
//
//  Created by xhj on 15/7/24.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Statuses.h"


@interface Comment : NSObject

@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,retain) User *user;

- (Comment *)initWithDictionary:(NSDictionary *)dictionary;

@end



@interface Comments : NSObject

@property (nonatomic,retain) NSMutableArray *comments;
@property (nonatomic,copy) NSString *total;

- (Comments *)initWithURL:(NSURL *)url;

@end
