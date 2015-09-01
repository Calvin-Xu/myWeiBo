//
//  DetailViewController.m
//  WeiBo
//
//  Created by xhj on 15/7/24.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "DetailViewController.h"
#import "HttpURL.h"
#import "CoreDataHelper.h"
#import "MJRefresh.h"

extern NSString *userAccessToken;

@interface DetailViewController (){
    NSInteger statusesHeight;
    NSInteger choice;
    NSInteger commentCellHeight;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;
    choice = 1;
//    self.accessToken = [CoreDataHelper queryAccess];
    NSString *url = [NSString stringWithFormat:@"%s?count=20&access_token=%@&id=%@",commentsURL,userAccessToken,self.statuses.idstr];
    self.comments = [[Comments alloc]initWithURL:[NSURL URLWithString:url]];
    [self setRefresh];
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
    }
    else{
        return self.comments.comments.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeTableViewCell *cell = [[HomeTableViewCell alloc] init];
        Statuses *s = self.statuses;
        User *user = s.user;
        NSLog(@"user id:%@",user.idstr);
        cell.userNameLabel.text = user.screen_name;
        cell.statusesTextLabel.text = s.text;
        cell.statusesText = s.text;
        CGRect textRect = [s.text boundingRectWithSize:CGSizeMake(368, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.statusesTextLabel.font} context:nil];
        //    NSLog(@"%f",textRect.size.height);
        [cell.statusesTextLabel setFrame:CGRectMake(10, 60, textRect.size.width, textRect.size.height)];
        statusesHeight = 60 + (long)textRect.size.height + 5;
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:user.profile_image_url]];
        UIImage *img = [[UIImage alloc] initWithData:data];
        cell.headImageView.image = img;
        NSLog(@"count:%d",s.thumbnail_pic.count);
        if (s.thumbnail_pic.count == 1) {
            NSLog(@"No!!!!");
            NSLog(@"th:%@",[s.thumbnail_pic objectAtIndex:0]);
            NSString *imgStr = [NSString stringWithString:[s.thumbnail_pic objectAtIndex:0]];
            imgStr = [imgStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgStr]];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:imgData]];
            imgView.frame = CGRectMake(10, 10 + statusesHeight, 348, 500);
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:imgView];
            statusesHeight = statusesHeight + 520;
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
        if (s.thumbnail_pic.count > 1 && s.thumbnail_pic.count <= 3) {
            statusesHeight= statusesHeight + 90;
        }
        else if (s.thumbnail_pic.count <= 6 && s.thumbnail_pic.count > 3) {
            statusesHeight = statusesHeight + 180;
        }
        else if(s.thumbnail_pic.count > 6) {
            statusesHeight = statusesHeight + 280;
        }
        if (self.retweetedStatus!=nil) {
            CGFloat reTop = statusesHeight;
            CGFloat reViewHeight = 0;
            UIView *reView = [[UIView alloc] initWithFrame:CGRectMake(0, reTop, 368, 0)];
            [reView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            //     [reView setBackgroundColor:[UIColor redColor]];
            [cell.contentView addSubview:reView];
            UILabel *retTextLabel = [[UILabel alloc] init];
            retTextLabel.text = self.retweetedStatus.text;
            retTextLabel.numberOfLines = 0;
            [retTextLabel setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
            //     [retTextLabel setBackgroundColor:[UIColor blueColor]];
            CGRect reTextRect = [self.retweetedStatus.text boundingRectWithSize:CGSizeMake(348, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.statusesTextLabel.font} context:nil];
            [retTextLabel setFrame:CGRectMake(10, reViewHeight+5, reTextRect.size.width, reTextRect.size.height)];
            statusesHeight = statusesHeight + (long)reTextRect.size.height + 10;
            reViewHeight = (long)reTextRect.size.height + 10;
            [reView addSubview:retTextLabel];
            
            if (self.retweetedStatus.thumbnail_pic.count == 1) {
                NSString *imgStr = [[self.retweetedStatus.thumbnail_pic objectAtIndex:0] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
                NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgStr]];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:imgData]];
                    imgView.frame = CGRectMake(10, 5+reViewHeight, 368, 500);
                    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [reView addSubview:imgView];
                statusesHeight = statusesHeight + 510;
                reViewHeight = reViewHeight + 510;
            }
            else{
                for (int i=0; i<self.retweetedStatus.thumbnail_pic.count; i++) {
                    //               NSLog(@"%d%@",i+1,[retweeted_status.thumbnail_pic objectAtIndex:i]);
                    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.retweetedStatus.thumbnail_pic objectAtIndex:i]]];
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
            if (self.retweetedStatus.thumbnail_pic.count > 1 && self.retweetedStatus.thumbnail_pic.count <= 3) {
                statusesHeight= statusesHeight + 90;
            }
            else if(self.retweetedStatus.thumbnail_pic.count<=6&&self.retweetedStatus.thumbnail_pic.count > 3) {
                statusesHeight = statusesHeight + 180;
            }
            else if(self.retweetedStatus.thumbnail_pic.count>6) {
                statusesHeight = statusesHeight + 280;
            }
            [reView setFrame:CGRectMake(0, reTop, 368, statusesHeight-reTop)];
        }
        return cell;
    }
    else{
        static NSString *identifier = @"commentCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (self.comments.comments.count != 0) {
            Comment *comment = [self.comments.comments objectAtIndex:indexPath.row];
            User *user = comment.user;
            UIButton *headImageButton = (UIButton *)[cell.contentView viewWithTag:101];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:user.profile_image_url]];
            [headImageButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            
            UIButton *userNameButton = [cell.contentView viewWithTag:102];
            [userNameButton setTitle:user.screen_name forState:UIControlStateNormal];
            
            UILabel *createdLabel = [cell.contentView viewWithTag:103];
            NSString *creatStr = [comment.created_at substringWithRange:NSMakeRange(4, 12)];
            [createdLabel setText:creatStr];
            [createdLabel setFrame:CGRectMake(60, 25, 200, 10)];
            
            UILabel *commentTextLable = [cell.contentView viewWithTag:104];
            [commentTextLable setText:comment.text];
            CGRect textRect = [comment.text boundingRectWithSize:CGSizeMake(298, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:commentTextLable.font} context:nil];
            //    NSLog(@"%f",textRect.size.height);
            [commentTextLable setFrame:CGRectMake(60, 45, textRect.size.width, textRect.size.height)];
            commentCellHeight = 45 + textRect.size.height;
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return statusesHeight;
    } else {
        return commentCellHeight + 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else {
        return 30.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 368, 30)];
        [headView setBackgroundColor:[UIColor whiteColor]];
        
        NSArray *segmentArray = [[NSArray alloc]initWithObjects:@"转发",@"评论",@"赞", nil];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
        segment.frame = CGRectMake(0, 0, 150, 30);
        segment.selectedSegmentIndex = 1;
        segment.tintColor = [UIColor clearColor];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:16],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
        [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,  [UIFont boldSystemFontOfSize:16],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
        [segment setTitleTextAttributes:dic2 forState:UIControlStateSelected];
        [headView addSubview:segment];
        [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        return headView;
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

- (void) sendMessage:(Statuses *)sta retweetedStatus:(Statuses *)reSta{
    self.statuses = sta;
    self.retweetedStatus = reSta;
}


-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
            
        case 0:
            choice = 0;
            break;
        case 1:
            choice = 1;
            break;
            
        case 2:
            choice = 2;
            break;
            
    }
    
}

- (void) setRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    self.tableView.footerRefreshingText = @"正在加载...";
}

- (void) footRefresh{
    NSString *url = [NSString stringWithFormat:@"%s?access_token=%@&count=%d&max_id=%@&id=%@",commentsURL, userAccessToken,11,[[self.comments.comments lastObject] idStr],self.statuses.idstr];
    //   numberOfStatuses += 10;
    NSUInteger i = 0;
    NSLog(@"upToRefresh url:%@",url);
    NSURL *URL = [NSURL URLWithString:url];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *rootStatues = [rootDic objectForKey:@"comments"];
    for(NSDictionary *dic in rootStatues)
    {
        if (i == 0) {
            ++ i;
            continue;
        }
        Comment *com = [[Comment alloc] initWithDictionary:dic];
        [self.comments.comments addObject:com];
        
    }
    NSLog(@"comments count:%d",[self.comments.comments count]);
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        //调用endRefreshing结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}



@end
