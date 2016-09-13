//
//  MediaCell.m
//  LaneTrip
//
//  Created by antsmen on 15-4-10.
//  Copyright (c) 2015年 antsmen. All rights reserved.
//

#import "MediaCell.h"
#import "MXVideoPlayer.h"

@interface MediaCell()
{
    UIImageView *photoView;
    MXVideoPlayer *videoView;
}

@end

@implementation MediaCell
@synthesize media;

- (void)setMedia:(Media *)aMedia
{
    media = aMedia;
    [self reset];
    if(!media){
        return;
    }
    if(media.type == MediaTypeImage){
        if(!photoView){
            photoView = [[UIImageView alloc] init];
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
        }
        if(!photoView.superview){
            [self addSubview:photoView];
        }
        [photoView mx_setImageWithURL:media.url placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    }else{
        if(!videoView){
            videoView = [[MXVideoPlayer alloc] initWithFrame:self.bounds];
        }
        if(!videoView.superview){
            [self addSubview:videoView];
        }
        [videoView setUrl:[NSURL URLWithString:media.url] Thumbnail:[NSURL URLWithString:media.thumbURL]];
    }
}

- (void)reset
{
    if(photoView){
        [photoView removeFromSuperview];
        [photoView mx_cancelCurrentImageLoad];
    }
    if(videoView){
        [videoView removeFromSuperview];
        [videoView stop];
    }
}

- (void)stopVideo
{
    if(media.type != MediaTypeVideo){
        return;
    }
    if(videoView){
        [videoView stop];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(photoView){
        photoView.frame = self.bounds;
    }
    if(videoView){
        videoView.frame = self.bounds;
    }
}

@end
