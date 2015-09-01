//
//  PersonalHomePageViewController.m
//  WeiBo
//
//  Created by xhj on 15/7/30.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "PersonalHomePageViewController.h"
#import "HomeTableViewCell.h"
#import "HttpURL.h"
extern NSString *userAccessToken;

@interface PersonalHomePageViewController (){
    UIActivityIndicatorView *indicator;
}

@end

@implementation PersonalHomePageViewController
@synthesize friendStatues,operationQueue;
- (void)viewDidLoad {
    [super viewDidLoad];
    operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(statuses) object:nil];
    [operationQueue addOperation:op];
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(169, 280, 30, 30)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicator.color = [UIColor grayColor];
    [self.tableView addSubview:indicator];
    [indicator startAnimating];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else{
        return [friendStatues.statuses count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self displayFirstSection:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }else{
        HomeTableViewCell *cell = [self displaySecondSection:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return cellHeight;
    }else{
        return 225;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 368, 30)];
        [headView setBackgroundColor:[UIColor whiteColor]];
        
        NSArray *segmentArray = [[NSArray alloc]initWithObjects:@"基本信息",@"微博",@"相册", nil];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
        segment.frame = CGRectMake(0, 0, 368, 30);
        segment.selectedSegmentIndex = 1;
        segment.tintColor = [UIColor clearColor];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:16],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
        [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:16],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
        [segment setTitleTextAttributes:dic2 forState:UIControlStateSelected];
        [headView addSubview:segment];
   //     [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else {
        return 30;
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) statuses{
    NSString *url = [NSString stringWithFormat:@"%s?access_token=%@&count=20",userStatusesURL, userAccessToken];
    NSURL *URL = [NSURL URLWithString:url];
    friendStatues = nil;
    friendStatues = [[FriendsStatuses alloc] initWithURL:URL];
 //   [self.tableView reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [indicator stopAnimating];
    NSLog(@"friendststuses:%@",friendStatues);
}

- (void) segmentAction{

}

- (void) sendUser:(User *)aUser{
    user = aUser;
}

- (UITableViewCell *) displayFirstSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    static NSString *cellIdentifier = @"personalCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *background;
    if (user.coverImage == nil) {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personalCoverImage"]];
    }
    else{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:user.coverImage]];
        background = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
    }
    cell.backgroundView = background;
    
    NSData *headData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profile_image_url]];
    UIImageView *headView = (UIImageView *) [self.tableView viewWithTag:150];
    [headView setImage:[[UIImage alloc] initWithData:headData]];
    UILabel *userNameLabel = (UILabel *) [self.tableView viewWithTag:101];
    userNameLabel.text = user.screen_name;
    
    UILabel *followingLabel = (UILabel *) [self.tableView viewWithTag:102];
    followingLabel.text = [NSString stringWithFormat:@"关注:%@",user.friends_count];
    
    UILabel *followedLabel = (UILabel *) [self.tableView viewWithTag:103];
    followedLabel.text = [NSString stringWithFormat:@"粉丝:%@",user.followers_count];
    return cell;
}
/*
- (UITableViewCell *) displaSecondSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSArray *segmentArray = [[NSArray alloc]initWithObjects:@"基本信息",@"微博",@"相册", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
    segment.frame = CGRectMake(0, 0, 368, 30);
    segment.selectedSegmentIndex = 1;
    segment.tintColor = [UIColor clearColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:16],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
    [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:16],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
    [segment setTitleTextAttributes:dic2 forState:UIControlStateSelected];
    [cell addSubview:segment];
    //     [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
}*/

- (HomeTableViewCell *) displaySecondSection:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (friendStatues == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return (HomeTableViewCell *)cell;
    }
    cellHeight = 0;
    /*  static NSString *identifier = @"homeCell";
     NSLog(@"row:%d",indexPath.row);
     HomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier ];
     if (cell == nil) {
     cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }*/
    HomeTableViewCell *cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = [friendStatues.statuses objectAtIndex:indexPath.row];
    Statuses *s = [arr objectAtIndex:0];
    //    NSLog(@"weib0 id:%@",s.idstr);
    User *user = s.user;
    cell.userNameLabel.text = user.screen_name;
    cell.statusesTextLabel.text = s.text;
    NSString *createdTime = [s.created_at substringToIndex:20];
    cell.createdTimeLabel.text = createdTime;
    cell.statusesText = s.text;
    CGRect textRect = [s.text boundingRectWithSize:CGSizeMake(368, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.statusesTextLabel.font} context:nil];
    //    NSLog(@"%f",textRect.size.height);
    [cell.statusesTextLabel setFrame:CGRectMake(10, 60, textRect.size.width, textRect.size.height)];
    cellHeight = 60 + (long)textRect.size.height + 5;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:user.profile_image_url]];
    UIImage *img = [[UIImage alloc] initWithData:data];
    cell.headImageView.image = img;
    if (s.thumbnail_pic.count<3&&s.thumbnail_pic.count>0) {
        for (int i=0; i<s.thumbnail_pic.count; i++) {
            //           NSLog(@"%d%@",i+1,[s.thumbnail_pic objectAtIndex:i]);
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[s.thumbnail_pic objectAtIndex:i]]];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:imgData]];
            imgView.frame = CGRectMake(10+105*i, 70+textRect.size.height, 100, 120);
            cell.imageView.contentMode = UIViewContentModeCenter;
            [cell.contentView addSubview:imgView];
        }
        cellHeight = cellHeight + 140;
    }
    else{
        for (int i=0; i<s.thumbnail_pic.count; i++) {
            //            NSLog(@"%d%@",i+1,[s.thumbnail_pic objectAtIndex:i]);
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[s.thumbnail_pic objectAtIndex:i]]];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:imgData]];
            if(i<3){
                imgView.frame = CGRectMake(10+85*i, 70+textRect.size.height, 80, 80);
            }
            else if(i<6){
                imgView.frame = CGRectMake(10+85*(i-3), 70+textRect.size.height+85, 80, 80);
            }
            else{
                imgView.frame = CGRectMake(10+85*(i-6), 70+textRect.size.height+85*2, 80, 80);
            }
            cell.imageView.contentMode = UIViewContentModeCenter;
            [cell.contentView addSubview:imgView];
            //           NSLog(@"i:%i",i);
        }
    }
    if (s.thumbnail_pic.count == 3) {
        cellHeight = cellHeight + 90;
    } else if (s.thumbnail_pic.count<=6&&s.thumbnail_pic.count>=3) {
        cellHeight = cellHeight + 180;
    }
    else if(s.thumbnail_pic.count>6) {
        cellHeight = cellHeight + 280;
    }
    
    Statuses *retweeted_status = [arr objectAtIndex:1];
    if (retweeted_status!=nil) {
        CGFloat reTop = cellHeight;
        CGFloat reViewHeight = 0;
        UIView *reView = [[UIView alloc] initWithFrame:CGRectMake(0, reTop, 368, 0)];
        [reView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        //     [reView setBackgroundColor:[UIColor redColor]];
        [cell.contentView addSubview:reView];
        UILabel *retTextLabel = [[UILabel alloc] init];
        retTextLabel.text = retweeted_status.text;
        retTextLabel.numberOfLines = 0;
        [retTextLabel setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        //     [retTextLabel setBackgroundColor:[UIColor blueColor]];
        CGRect reTextRect = [retweeted_status.text boundingRectWithSize:CGSizeMake(368, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.statusesTextLabel.font} context:nil];
        [retTextLabel setFrame:CGRectMake(10, reViewHeight+5, reTextRect.size.width, reTextRect.size.height)];
        cellHeight = cellHeight + (long)reTextRect.size.height + 10;
        reViewHeight = (long)reTextRect.size.height + 10;
        [reView addSubview:retTextLabel];
        
        if (retweeted_status.thumbnail_pic.count<3&&retweeted_status.thumbnail_pic.count>0) {
            for (int i=0; i<retweeted_status.thumbnail_pic.count; i++) {
                //               NSLog(@"%d%@",i+1,[retweeted_status.thumbnail_pic objectAtIndex:i]);
                NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[retweeted_status.thumbnail_pic objectAtIndex:i]]];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:imgData]];
                imgView.frame = CGRectMake(10+105*i, 5+reViewHeight, 100, 120);
                cell.imageView.contentMode = UIViewContentModeCenter;
                [reView addSubview:imgView];
            }
            cellHeight = cellHeight + 130;
            reViewHeight = reViewHeight + 130;
        }
        else{
            for (int i=0; i<retweeted_status.thumbnail_pic.count; i++) {
                //               NSLog(@"%d%@",i+1,[retweeted_status.thumbnail_pic objectAtIndex:i]);
                NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[retweeted_status.thumbnail_pic objectAtIndex:i]]];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:imgData]];
                if(i<3){
                    imgView.frame = CGRectMake(10+85*i, 5+reViewHeight, 80, 80);
                }
                else if(i<6){
                    imgView.frame = CGRectMake(10+85*(i-3), 5+reViewHeight+85, 80, 80);
                }
                else{
                    imgView.frame = CGRectMake(10+85*(i-6), 5+reViewHeight+85*2, 80, 80);
                }
                cell.imageView.contentMode = UIViewContentModeCenter;
                [reView addSubview:imgView];
                //                NSLog(@"i:%i",i);
            }
        }
        if (retweeted_status.thumbnail_pic.count==3) {
            cellHeight = cellHeight + 90;
        }
        else if(retweeted_status.thumbnail_pic.count<=6&&retweeted_status.thumbnail_pic.count>=3) {
            cellHeight = cellHeight + 180;
        }
        else if(retweeted_status.thumbnail_pic.count>6) {
            cellHeight = cellHeight + 280;
        }
        [reView setFrame:CGRectMake(0, reTop, 368, cellHeight-reTop)];
    }
    [cell setFrame:CGRectMake(0, 0, 368, cellHeight)];
    if ([friendStatues.statuses count] != 0 && (indexPath.row == [friendStatues.statuses count] - 1)) {
      //  [indicator stopAnimating];
        NSLog(@"stop it!");
    }
    return cell;
}

@end
