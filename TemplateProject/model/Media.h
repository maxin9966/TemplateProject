//
//  Media.h
//  LaneTrip
//
//  Created by antsmen on 15-4-10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MediaType) {
    MediaTypeImage = 1,
    MediaTypeVideo = 2,
    MediaTypeAudio = 3,
};

@interface Media : NSObject

@property (nonatomic,assign) NSInteger _id;
@property (nonatomic,assign) MediaType type;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSURL *thumbURL;

+ (id)initWithDict:(NSDictionary*)dict;

@end
