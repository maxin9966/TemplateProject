//
//  StarManager.h
//  TemplateProject
//
//  Created by admin on 15/7/14.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Media.h"

@interface StarManager : NSObject

+ (instancetype)sharedInstance;

- (AFHTTPRequestOperation*)getStarsWithCompletion:(ArrayBlock)completion;

@end

@interface Star : NSObject

@property (nonatomic,assign) NSInteger _id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *coverImageURL;
@property (nonatomic,strong) NSString *info;
@property (nonatomic,strong) NSMutableArray *photoList;
@property (nonatomic,strong) NSString *siteInfoImageURL;

+ (id)initWithDict:(NSDictionary*)dict;

@end