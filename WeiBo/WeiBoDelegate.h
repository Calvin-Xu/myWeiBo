//
//  WeiBoDelegate.h
//  WeiBo
//
//  Created by xhj on 15/7/30.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@protocol WeiBoDelegate <NSObject>

- (void) sendUser:(User *) aUser;

@end

@interface WeiBoDelegate : NSObject


@end
