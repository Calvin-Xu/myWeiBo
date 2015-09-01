//
//  HomeTableViewCell.m
//  WeiBo
//
//  Created by alex  on 15/6/20.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell
@synthesize userNameLabel,headImageView,statusesTextLabel,statusesText,createdTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 235, 20)];
        [self.userNameLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.8]];
        [self.userNameLabel setFont:[UIFont systemFontOfSize:15]];
        self.createdTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, 200, 10)];
        [self.createdTimeLabel setFont:[UIFont systemFontOfSize:10]];
        self.statusesTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60,368, 300)];
        self.statusesTextLabel.numberOfLines = 0;

        [self.contentView addSubview:headImageView];
        [self.contentView addSubview:userNameLabel];
        [self.contentView addSubview:createdTimeLabel];
        [self.contentView addSubview:statusesTextLabel];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
       
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
