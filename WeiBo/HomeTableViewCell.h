//
//  HomeTableViewCell.h
//  WeiBo
//
//  Created by alex  on 15/6/20.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *statusesText;
@property (nonatomic, retain) UILabel *statusesTextLabel;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UIImageView *statusesImage;
@property (nonatomic, retain) UILabel *createdTimeLabel;

@end
