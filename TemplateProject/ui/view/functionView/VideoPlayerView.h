//
//  VideoPlayerView.h
//  MeiMei
//
//  Created by 马鑫 on 14-4-22.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    视频播放器
 */

#define ControlsOffsetY -28

typedef NS_ENUM(NSUInteger, VideoPlayMode) {
    VideoPlayModeDefault = 0,
    VideoPlayModeFullScreen = 1
};

@protocol VideoPlayerViewDelegate <NSObject>

- (void)videoPlayerViewDelegatePlaybackDidFinish;

@end

@interface VideoPlayerView : UIView

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,weak) id<VideoPlayerViewDelegate> delegate;
@property (nonatomic,assign) VideoPlayMode playMode;

@property (nonatomic,strong,readonly) UIImage *thumbnail;

- (void)setUrl:(NSURL *)mUrl Thumbnail:(NSURL*)tUrl;

- (void)play;

- (void)stop;

- (void)clear;

@end
