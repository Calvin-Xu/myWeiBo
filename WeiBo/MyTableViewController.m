//
//  MyTableViewController.m
//  WeiBo
//
//  Created by alex  on 15/5/31.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "MyTableViewController.h"
#import "HttpURL.h"
#import "PersonalHomePageViewController.h"
extern NSString *userAccessToken;
extern NSString *uidStr;

@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self myUserMessage];
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section ==0 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell2" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *weiboButton = [self.tableView viewWithTag:111];
        NSString *weiboStr = [NSString stringWithFormat:@"微博 %@",self.myUser.statuses_count];
        [weiboButton setTitle:weiboStr forState:UIControlStateNormal];
        [weiboButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateSelected];
     
        UIButton *followingButton = [self.tableView viewWithTag:112];
        NSString *followingStr = [NSString stringWithFormat:@"关注 %@",self.myUser.friends_count];
        [followingButton setTitle:followingStr forState:UIControlStateNormal];
        
        UIButton *followedButton = [self.tableView viewWithTag:113];
        NSString *followedStr = [NSString stringWithFormat:@"粉丝 %@",self.myUser.followers_count];
        [followedButton setTitle:followedStr forState:UIControlStateNormal];
    }
    else {
        static NSString *identifier = @"myCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.section == 0 && indexPath.row == 0){
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.myUser.profile_image_url]];
            UIImage *img = [[UIImage alloc] initWithData:data];
            cell.imageView.image = img;
            cell.textLabel.text = self.myUser.screen_name;
            //   NSLog(@"description:%@",user.userDescription);
            cell.detailTextLabel.text = self.myUser.userDescription;
        }
        else if (indexPath.section == 1 && indexPath.row == 0){
            cell.textLabel.text = @"赞";
            cell.detailTextLabel.text = nil;
        }
        else{
            cell.textLabel.text = @"设置";
            cell.detailTextLabel.text = nil;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
            return 60;
    }else{
        return 50;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0){
        PersonalHomePageViewController *myHomePageController = [self.storyboard instantiateViewControllerWithIdentifier:@"personalController"];
        self.delegate = myHomePageController;
        [self.delegate sendUser:self.myUser];
        [self.navigationController pushViewController:myHomePageController animated:YES];
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

- (void) myUserMessage{
    NSString *url = [NSString stringWithFormat:@"%s?access_token=%@&uid=%@",userURL, userAccessToken,uidStr];
    NSLog(@"myUser url:%@",url);
    NSError *error = nil;
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSDate *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    self.myUser = [[User alloc]initWithDictionary:rootDic];
}



@end
