//
//  HomeTableViewController.h
//  WeiBo
//
//  Created by alex  on 15/6/20.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FriendsStatuses.h"

@protocol HomeTableViewControllerDelegate <NSObject>

- (void) sendMessage:(Statuses *) sta retweetedStatus:(Statuses *) reSta;

@end

@interface HomeTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)AppDelegate* myAppDelegate;
//@property(nonatomic,readonly)NSString* accessToken;
@property(nonatomic,retain)FriendsStatuses* statuses;
@property(nonatomic,copy)FriendsStatuses *friendStatues;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic,retain) UIRefreshControl *pullToRefresh;
@property (nonatomic,retain) NSOperationQueue *operationQueue;
@property (nonatomic) NSInteger numberOfStatuses;

@property (nonatomic,weak) id <HomeTableViewControllerDelegate> delegate;
@end