//
//  MediaCell.h
//  LaneTrip
//
//  Created by antsmen on 15-4-10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "ImageScrollView.h"
#import "Media.h"

@interface MediaCell : ImageCell

@property (nonatomic,assign) Media *media;

- (void)stopVideo;

@end
