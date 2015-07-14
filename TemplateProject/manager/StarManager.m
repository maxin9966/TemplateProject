//
//  StarManager.m
//  TemplateProject
//
//  Created by admin on 15/7/14.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "StarManager.h"

@implementation StarManager

@end

@implementation Star

+ (id)initWithDict:(NSDictionary*)dict
{
    if(!dict.count){
        return nil;
    }
    Star *instance = [Star new];
    instance._id = [[dict objectForKeySafely:@"id"] integerValue];
    instance.info = [dict objectForKeySafely:@"brief"];
    instance.coverImageURL = [dict objectForKeySafely:@"coverUrl"];
    instance.name = [dict objectForKeySafely:@"title"];
    instance.siteInfoImageURL = [dict objectForKeySafely:@"url"];
    NSArray *photoDicts = [dict objectForKeySafely:@"imageInfos"];
    instance.photoList = [NSMutableArray array];
    for(NSDictionary *dict in photoDicts){
        [instance.photoList addObject:[Media initWithDict:dict]];
    }
    return instance;
}

@end