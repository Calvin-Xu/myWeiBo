//
//  TabBarController.m
//  WeiBo
//
//  Created by alex  on 15/5/31.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "TabBarController.h"
#import "HomeTableViewController.h"
#import "MessageTableViewController.h"
#import "FollowingViewController.h"
#import "MyTableViewController.h"
#import "WeiboSDK.h"
@interface TabBarController ()

@end

@implementation TabBarController


- (void)loadView{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   /*
    HomeTableViewController *homeView = [[HomeTableViewController alloc]init];
    UITabBarItem *homeItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home"] tag:101];
    homeView.tabBarItem = homeItem;
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeView];
    
    MessageTableViewController *messageView = [[MessageTableViewController alloc]init];
    UITabBarItem *messageItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage imageNamed:@"message"] tag:102];
    messageView.tabBarItem = messageItem;
    UINavigationController *messageNav = [[UINavigationController alloc]initWithRootViewController:messageView];
    
    FindTableViewController *findView = [[FindTableViewController alloc]init];
    UITabBarItem *findItem = [[UITabBarItem alloc]initWithTitle:@"发现" image:[UIImage imageNamed:@"find"] tag:103];
    UINavigationController *findNav = [[UINavigationController alloc]initWithRootViewController:findView];
    findView.tabBarItem = findItem;
    
    MyTableViewController *myView = [[MyTableViewController alloc]init];
    UITabBarItem *myItem = [[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"my"] tag:104];
    myView.tabBarItem = myItem;
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:myView];
    
    NSArray *controller = @[homeNav,messageNav,findNav,myNav];
    [self setViewControllers:controller];*/
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
