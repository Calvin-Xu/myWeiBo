//
//  User.m
//  WeiBo
//
//  Created by alex  on 15/6/19.
//  Copyright (c) 2015年 alex . All rights reserved.
//

#import "User.h"

@implementation User
@synthesize idstr,ability_tags,screen_name,location,gender,followers_count,friends_count,statuses_count,favourites_count,online_status,verified,bi_followers_count,attitudes_count,allow_all_act_msg,profile_image_url,avatar_large,avatar_hd,created_at,domain,userDescription,coverImage;
- (User *)initWithDictionary:(NSDictionary *)dictionary
{
    self.idstr = [dictionary objectForKey:@"idstr"];
    self.ability_tags = [dictionary objectForKey:@"ability_tags"];
    self.screen_name = [dictionary objectForKey:@"screen_name"];
    self.location = [dictionary objectForKey:@"location"];
    self.gender = [dictionary objectForKey:@"gender"];
    self.followers_count = [dictionary objectForKey:@"followers_count"];
    self.friends_count = [dictionary objectForKey:@"friends_count"];
    self.statuses_count = [dictionary objectForKey:@"statuses_count"];
    self.favourites_count = [dictionary objectForKey:@"favourites_count"];
    self.online_status = [dictionary objectForKey:@"online_status"];
    self.verified = [dictionary objectForKey:@"verified"];
    self.bi_followers_count = [dictionary objectForKey:@"bi_followers_count"];
    self.attitudes_count = [dictionary objectForKey:@"attitudes_count"];
    self.allow_all_act_msg = [dictionary objectForKey:@"allow_all_act_msg"];
    self.profile_image_url = [dictionary objectForKey:@"profile_image_url"];
    self.avatar_large = [dictionary objectForKey:@"avatar_large"];
    self.avatar_hd = [dictionary objectForKey:@"avatar_hd"];
    self.created_at = [dictionary objectForKey:@"created_at"];
    self.userDescription = [dictionary objectForKey:@"description"];
    self.domain = [dictionary objectForKey:@"domain"];
    self.coverImage = [dictionary objectForKey:@"cover_image_phone"];
    return self;
}
@end
