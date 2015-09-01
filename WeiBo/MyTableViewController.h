//
//  MyTableViewController.h
//  WeiBo
//
//  Created by alex  on 15/5/31.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "WeiBoDelegate.h"


@interface MyTableViewController : UITableViewController <WeiBoDelegate>

@property (nonatomic,retain) User *myUser;
@property (nonatomic,retain) id <WeiBoDelegate> delegate;

@end
