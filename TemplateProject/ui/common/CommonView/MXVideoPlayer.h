//
//  MXVideoPlayer.h
//  MeiMei
//
//  Created by 马鑫 on 14-4-22.
//  Copyright (c) 2014年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    视频播放器
 */

#define ControlsOffsetY -25.f

typedef NS_ENUM(NSUInteger, VideoPlayerMode) {
    VideoPlayerModeDefault = 0,
    VideoPlayerModeFullScreen = 1
};

@protocol MXVideoPlayerDelegate <NSObject>

- (void)videoPlayerDelegatePlaybackDidFinish;

@end

@interface MXVideoPlayer : UIView

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,weak) id<MXVideoPlayerDelegate> delegate;
@property (nonatomic,assign) VideoPlayerMode playerMode;

@property (nonatomic,strong,readonly) UIImage *thumbnail;

- (void)setUrl:(NSURL *)mUrl Thumbnail:(NSURL*)tUrl;

- (void)play;

- (void)stop;

- (void)clear;

@end
