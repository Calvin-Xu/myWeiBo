//
//  User.h
//  WeiBo
//
//  Created by alex  on 15/6/19.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
- (User *)initWithDictionary:(NSDictionary *)dictionary;
@property(nonatomic,copy) NSString* idstr;          //字符串型的用户UID
@property(nonatomic,copy) NSString* ability_tags;   //微博创建时间
@property(nonatomic,copy) NSString* screen_name ;   //用户昵称
@property(nonatomic,copy) NSString* location ;      //用户所在地
@property(nonatomic,copy) NSString* gender ;        //性别，m：男、f：女、n：未知
@property(nonatomic,copy) NSString* followers_count;    //粉丝数
@property(nonatomic,copy) NSString* friends_count;      //关注数
@property(nonatomic,copy) NSString* statuses_count;     //微博数
@property(nonatomic,copy) NSString* favourites_count;   //收藏数
@property(nonatomic,copy) NSString* online_status;          //用户的在线状态，0：不在线、1：在线
@property(nonatomic,copy) NSString* verified;                 //是否是微博认证用户，即加V用户，true：是，false：否
@property(nonatomic,copy) NSString* bi_followers_count;     //用户的互粉数
@property(nonatomic,copy) NSString* attitudes_count;   //表态数
@property(nonatomic,copy) NSString* allow_all_act_msg;        //是否允许所有人给我发私信，true：是，false：否
@property(nonatomic,copy) NSString* profile_image_url ; //用户头像地址（中图），50×50像素
@property(nonatomic,copy) NSString* avatar_large;       //用户头像地址（大图），180×180像素
@property(nonatomic,copy) NSString* avatar_hd;          //用户头像地址（高清），高清头像原图
@property(nonatomic,copy) NSString* created_at;         //用户创建（注册）时间
@property(nonatomic,copy) NSString* userDescription;   //用户个人描述
@property(nonatomic,copy) NSString* domain;        //用户的个性化域名
@property(nonatomic,copy) NSString* coverImage;    //用户信息封面

@end
