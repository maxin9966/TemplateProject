//
//  Media.m
//  LaneTrip
//
//  Created by antsmen on 15-4-10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "Media.h"

@implementation Media
@synthesize _id,type,url,thumbURL;

+ (id)initWithDict:(NSDictionary*)dict
{
    if(!dict.count){
        return nil;
    }
    Media *instance = [Media new];
    instance.type = [[dict objectForKeySafely:@"mediaType"] integerValue];
    instance._id = [[dict objectForKeySafely:@"id"] integerValue];
    instance.url = [NSURL URLWithString:[dict stringForKeyNonNil:@"url"]];
    instance.thumbURL = [NSURL URLWithString:[dict stringForKeyNonNil:@"thumbUrl"]];
    return instance;
}

@end
