//
//  DetailViewController.h
//  WeiBo
//
//  Created by xhj on 15/7/24.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "Comments.h"
@interface DetailViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,HomeTableViewControllerDelegate>

@property (nonatomic,retain) Statuses *statuses;
@property (nonatomic,retain) Statuses *retweetedStatus;
//@property (nonatomic,retain) NSString *accessToken;
@property (nonatomic,retain) Comments *comments;
@end
