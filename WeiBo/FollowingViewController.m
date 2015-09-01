//
//  FollowingViewController.m
//  WeiBo
//
//  Created by xhj on 15/7/29.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "FollowingViewController.h"
#import "HttpURL.h"
#import "User.h"
#import "MJRefresh.h"
#import "PersonalHomePageViewController.h"

extern NSString *uidStr;
extern NSString *userAccessToken;

@interface FollowingViewController ()

@end

@implementation FollowingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self followingList];
    [self setupRefresh];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.followingLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"followingCell";
   // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    User *user = [self.followingLists objectAtIndex:indexPath.row];
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:user.profile_image_url]];
    UIImage *img = [[UIImage alloc] initWithData:data];
    cell.imageView.image = img;
//    cell.imageView.frame = CGRectMake(10, 5, 30, 30);
    cell.textLabel.text = user.screen_name;
 //   NSLog(@"description:%@",user.userDescription);
    cell.detailTextLabel.text = user.userDescription;
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        PersonalHomePageViewController *oneHomePageController = [self.storyboard instantiateViewControllerWithIdentifier:@"personalController"];
        self.delegate = oneHomePageController;
        User *user = [self.followingLists objectAtIndex:indexPath.row];
        [self.delegate sendUser:user];
        [self.navigationController pushViewController:oneHomePageController animated:YES];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
*/
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



- (void)followingList{
    self.followingLists = [[NSMutableArray alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s?access_token=%@&uid=%@&count=90",followingURL, userAccessToken,uidStr];
    NSLog(@"followingURL:%@",url);
    NSURL *URL = [NSURL URLWithString:url];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *rootStatues = [rootDic objectForKey:@"users"];
    for(NSDictionary *dic in rootStatues)
    {
        User *user = [[User alloc] initWithDictionary:dic];
        [self.followingLists addObject:user];
    }
    cursor = [rootDic objectForKey:@"next_cursor"];
    totalFollowing = [rootDic objectForKey:@"total_number"];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
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
    NSString *url = [NSString stringWithFormat:@"%s?access_token=%@&uid=%@&count=90",followingURL, userAccessToken,uidStr];
    NSURL *URL = [NSURL URLWithString:url];
    [self.followingLists removeAllObjects];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *rootStatues = [rootDic objectForKey:@"users"];
    for(NSDictionary *dic in rootStatues)
    {
        User *user = [[User alloc] initWithDictionary:dic];
        [self.followingLists addObject:user];
    }
    cursor = [rootDic objectForKey:@"next_cursor"];
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
    if (cursor.intValue <= totalFollowing.intValue && cursor.intValue != 0) {
        NSString *url = [NSString stringWithFormat:@"%s?access_token=%@&uid=%@&count=90&cursor=%@",followingURL, userAccessToken,uidStr,cursor];
        NSLog(@"upToRefresh url:%@",url);
        NSError *error = nil;
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSArray *rootStatues = [rootDic objectForKey:@"users"];
        for(NSDictionary *dic in rootStatues)
        {
            User *user = [[User alloc] initWithDictionary:dic];
            [self.followingLists addObject:user];
        }
        cursor = [rootDic objectForKey:@"next_cursor"];
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [self.tableView reloadData];
            //调用endRefreshing结束刷新状态
            [self.tableView footerEndRefreshing];
        });
    }
    else{
        [self.tableView footerEndRefreshing];
    }
    
}



@end
