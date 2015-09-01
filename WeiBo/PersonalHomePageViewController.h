//
//  PersonalHomePageViewController.h
//  WeiBo
//
//  Created by xhj on 15/7/30.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "WeiBoDelegate.h"
#import "FriendsStatuses.h"
@interface PersonalHomePageViewController : UITableViewController <WeiBoDelegate,UITableViewDelegate,UITableViewDataSource>{
    User *user;
    CGFloat cellHeight;
}
@property(nonatomic,copy)FriendsStatuses *friendStatues;
@property (nonatomic,retain) NSOperationQueue *operationQueue;

@end
