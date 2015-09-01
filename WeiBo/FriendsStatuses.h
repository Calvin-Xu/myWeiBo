//
//  FriendsStatuses.h
//  WeiBo
//
//  Created by alex  on 15/6/19.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Statuses.h"
@interface FriendsStatuses : NSObject

- (FriendsStatuses *)initWithURL:(NSURL *)url;
@property(nonatomic,copy) NSMutableArray* statuses;

@end
