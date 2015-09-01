//
//  Statuses.h
//  WeiBo
//
//  Created by alex  on 15/6/19.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Statuses : NSObject
- (Statuses *)initWithDictionary:(NSDictionary *)dictionary;
@property(nonatomic,copy) User* user;             //用户
@property(nonatomic,copy) NSString* created_at;   //微博创建时间
@property(nonatomic,copy) NSString* comments_count;    //评论数
@property(nonatomic,copy) NSString* attitudes_count;   //表态数
@property(nonatomic,copy) NSString* favorited;           //是否已收藏，true：是，false：否
@property(nonatomic,copy) NSString* text;          //微博信息内容
@property(nonatomic,copy) NSString* idstr;         //微博id
@property(nonatomic,copy) NSString* reposts_count;     //转发数
@property(nonatomic,copy) NSString* source;
@property NSMutableArray* thumbnail_pic;  //缩略图片地址，没有时不返回此字段
@property(nonatomic,copy) NSMutableArray* bmiddle_pic;    //中等尺寸图片地址，没有时不返回此字段
@property(nonatomic,copy) NSMutableArray* original_pic;   //原始图片地址，没有时不返回此字段


@end
