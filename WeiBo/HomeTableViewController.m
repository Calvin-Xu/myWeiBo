//
//  HomeTableViewController.m
//  WeiBo
//
//  Created by alex  on 15/6/20.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "HomeTableViewController.h"
#import "WeiboSDK.h"
#import "AccessToken.h"
#import <CoreData/CoreData.h>
#import "CoreDataHelper.h"
#import "HttpHelper.h"
#import "FriendsStatuses.h"
#import "HomeTableViewCell.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "HttpURL.h"

NSString *userAccessToken;
NSString *uidStr;

@interface HomeTableViewController (){
    BOOL isUpdate;
}
@end

@implementation HomeTableViewController

@synthesize statuses;
@synthesize friendStatues;
@synthesize cellHeight;
@synthesize pullToRefresh,operationQueue;
@synthesize numberOfStatuses;
- (void)viewDidLoad {
    [super viewDidLoad];
    isUpdate = NO;
    userAccessToken = [CoreDataHelper queryAccess];
    _myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    while (userAccessToken==nil) {
        [HttpHelper askAccess];
        break;
    }
    numberOfStatuses = 0;
 /*   NSLog(@"httpRequest FriendStatuses!");
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/friends_timeline.json?access_token=%@&count=20",accessToken];
    NSLog(@"%@",url);
    NSURL *URL = [NSURL URLWithString:url];
    friendStatues = [[FriendsStatuses alloc] initWithURL:URL];
    NSLog(@"1111:%d",[self.friendStatues.statuses count]);*/
    operationQueue = [[NSOperationQueue alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self setupRefresh];
    [self userId];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [friendStatues.statuses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cellHeight = 0;
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
    NSString *createdTime = [s.created_at substringToIndex:20];
    cell.createdTimeLabel.text = createdTime;
    User *user = s.user;
    cell.userNameLabel.text = user.screen_name;
    cell.statusesTextLabel.text = s.text;
    cell.statusesText = s.text;
    CGRect textRect = [s.text boundingRectWithSize:CGSizeMake(368, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.statusesTextLabel.font} context:nil];
//    NSLog(@"%f",textRect.size.height);
    [cell.statusesTextLabel setFrame:CGRectMake(10, 60, textRect.size.width, textRect.size.height)];
    self.cellHeight = 60 + (long)textRect.size.height + 5;
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
        self.cellHeight = self.cellHeight + 140;
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
        self.cellHeight = self.cellHeight + 90;
    } else if (s.thumbnail_pic.count<=6&&s.thumbnail_pic.count>=3) {
        self.cellHeight = self.cellHeight + 180;
    }
    else if(s.thumbnail_pic.count>6) {
        self.cellHeight = self.cellHeight + 280;
    }
    
    Statuses *retweeted_status = [arr objectAtIndex:1];
    if (retweeted_status!=nil) {
        CGFloat reTop = self.cellHeight;
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
        self.cellHeight = self.cellHeight + (long)reTextRect.size.height + 10;
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
            self.cellHeight = self.cellHeight + 130;
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
            self.cellHeight = self.cellHeight + 90;
        }
        else if(retweeted_status.thumbnail_pic.count<=6&&retweeted_status.thumbnail_pic.count>=3) {
            self.cellHeight = self.cellHeight + 180;
        }
        else if(retweeted_status.thumbnail_pic.count>6) {
            self.cellHeight = self.cellHeight + 280;
        }
        [reView setFrame:CGRectMake(0, reTop, 368, self.cellHeight-reTop)];
    }
    [cell setFrame:CGRectMake(0, 0, 368, self.cellHeight)];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSArray *arr = [friendStatues.statuses objectAtIndex:indexPath.row];
    Statuses *s = [arr objectAtIndex:0];
    Statuses *retweeted_status = [arr objectAtIndex:1];
    self.delegate = detailController;
    [self.delegate sendMessage:s retweetedStatus:retweeted_status];
    [self.navigationController pushViewController:detailController animated:YES];
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
/*
- (void)pulltoRefresh{
    NSLog(@"pull to refresh!");
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(pullRefresh) object:nil];
    [operationQueue addOperation:op];
}

*/
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"正在刷新...";
    
    self.tableView.footerPullToRefreshText = @"上拉加载更多";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载";
    self.tableView.footerRefreshingText = @"正在加载...";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加数据
    NSLog(@"hahahahah");
    NSString *url = [NSString stringWithFormat:@"%s?access_token=%@&count=20",statusesURL, userAccessToken];
    NSURL *URL = [NSURL URLWithString:url];
    friendStatues = nil;
    friendStatues = [[FriendsStatuses alloc] initWithURL:URL];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        NSLog(@"NONONO");
        //调用endRefreshing结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加数据
    NSLog(@"id:%@",[[[self.friendStatues.statuses lastObject] objectAtIndex:0] idstr]);
    NSString *url = [NSString stringWithFormat:@"%s?access_token=%@&count=%d&max_id=%@",statusesURL, userAccessToken,11,[[[self.friendStatues.statuses lastObject] objectAtIndex:0] idstr]];
 //   numberOfStatuses += 10;
    NSUInteger i = 0;
    NSLog(@"upToRefresh url:%@",url);
    NSURL *URL = [NSURL URLWithString:url];
    Statuses *statuses = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *rootStatues = [rootDic objectForKey:@"statuses"];
    for(NSDictionary *dic in rootStatues)
    {
        if (i == 0) {
            ++ i;
            continue;
        }
        Statuses *stat = [[Statuses alloc] initWithDictionary:dic];
        NSDictionary *retweetedDictionary = [dic objectForKey:@"retweeted_status"];
        Statuses *retweeted_status = [[Statuses alloc] initWithDictionary:retweetedDictionary];
        NSArray *s = [NSArray arrayWithObjects:stat,retweeted_status,nil];
        [friendStatues.statuses addObject:s];
        
    }
    NSLog(@"statues count:%d",[self.friendStatues.statuses count]);
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        //调用endRefreshing结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

- (void) userId{
    NSString *url = [NSString stringWithFormat:@"%s?access_token=%@",userIdURL, userAccessToken];
    //   numberOfStatuses += 10;
    NSLog(@"userId url:%@",url);
    NSURL *URL = [NSURL URLWithString:url];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    uidStr = [rootDic objectForKey:@"uid"];
}


@end
