//
//  CoreDataHelper.m
//  WeiBo
//
//  Created by alex  on 15/6/4.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "CoreDataHelper.h"
#import "AccessToken.h"
@implementation CoreDataHelper


+ (NSString *)queryAccess   //查询accessToken
{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccessToken"inManagedObjectContext:myAppDelegate.managedObjectContext];
    //设置请求实体
    [request setEntity:entity];
    //指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accessToken"ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"error");
    }
    if ([mutableFetchResult count]==0) {
        return nil;
    }
    NSLog(@"The count of entry:%lu",(unsigned long)[mutableFetchResult count]);
    
    AccessToken *access = [mutableFetchResult objectAtIndex:0];
    NSLog(@"accessToken:%@",access.accessToken);
    return access.accessToken;

}

+ (void)del {                       //删除accessToken
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:@"AccessToken" inManagedObjectContext:myAppDelegate.managedObjectContext];
    [request setEntity:entity];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"accessToken==%@",@"helloAlex"];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    for (AccessToken* entry in mutableFetchResult) {
        [myAppDelegate.managedObjectContext deleteObject:entry];
    }
    
    if ([myAppDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

+ (void)insert:(NSString *)accessToken{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AccessToken *access = [NSEntityDescription insertNewObjectForEntityForName:@"AccessToken" inManagedObjectContext:myAppDelegate.managedObjectContext];
    access.accessToken = accessToken;
    NSLog(@"%@",access.accessToken);
    NSError *error2;
    if(![myAppDelegate.managedObjectContext save:&error2])
    {
        NSLog(@"error2");
    }

}

//更新accessToken
+ (void)updateAccess:(NSString *)oldAccessToken newAccessToken:(NSString *)newAccess{
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:@"AccessToken" inManagedObjectContext:myAppDelegate.managedObjectContext];
    [request setEntity:entity];
    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"accessToken==%@",oldAccessToken];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    //保存
    for (AccessToken* access in mutableFetchResult) {
        [access setAccessToken:newAccess];
    }
    [myAppDelegate.managedObjectContext save:&error];
}

@end
