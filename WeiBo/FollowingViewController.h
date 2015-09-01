//
//  FollowingViewController.h
//  WeiBo
//
//  Created by xhj on 15/7/29.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiBoDelegate.h"
@interface FollowingViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,WeiBoDelegate>{
    NSNumber *cursor;;
    NSNumber *totalFollowing;
}

@property (nonatomic,retain) NSMutableArray *followingLists;
@property (nonatomic,retain)id <WeiBoDelegate> delegate;

@end
